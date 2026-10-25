<?php
declare(strict_types=1);
namespace Hls\Services;

use Hls\Http\HttpError;
use Hls\Database;
use Hls\Repositories\ExpeditionRepository;

/** Quantity allocation primitives for the additive Model B path. */
final class ManifestAllocation
{
    public function __construct(private readonly ExpeditionRepository $data) {}

    public function ready(): bool
    {
        $q = $this->data->repo->one("SELECT COUNT(*) n FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name IN ('exp_manifest_allocations','exp_receipt_lines')");
        return (int)($q['n'] ?? 0) === 2;
    }

    public function balance(int $dnId, bool $lock = false): array
    {
        if (!$this->ready()) throw new HttpError(503, 'Fondasi Model B belum diaktifkan pada database ini.');
        $dn = $this->data->find('dn', $dnId, $lock);
        $allocated = (float)($this->data->repo->one(
            "SELECT COALESCE(SUM(quantity),0) total FROM exp_manifest_allocations WHERE dn_id=? AND status IN ('ALLOCATED','LOADED','IN_TRANSIT','ARRIVED')" . ($lock ? ' FOR UPDATE' : ''),
            [$dnId]
        )['total'] ?? 0);
        $received = (float)($this->data->repo->one(
            "SELECT COALESCE(SUM(rl.quantity_received),0) total FROM exp_receipt_lines rl JOIN exp_manifest_allocations a ON a.id=rl.allocation_id WHERE a.dn_id=?",
            [$dnId]
        )['total'] ?? 0);
        $quantity = (float)$dn['quantity'];
        $available = max(0.0, $quantity - $allocated - $received);
        return ['quantity'=>$quantity,'allocated'=>$allocated,'received'=>$received,'available'=>$available];
    }

    public function assertQuantity(int $dnId, float $quantity, string $unit, bool $lock = true): array
    {
        if ($quantity <= 0 || !is_finite($quantity)) throw new HttpError(422, 'Quantity alokasi harus lebih besar dari nol.');
        $balance = $this->balance($dnId, $lock);
        if (strcasecmp(trim($unit), trim((string)$this->data->find('dn', $dnId)['unit'])) !== 0) throw new HttpError(422, 'Satuan alokasi tidak sesuai dengan DN.');
        if ($quantity > $balance['available'] + 0.000001) throw new HttpError(409, 'Quantity melebihi saldo DN yang tersedia.');
        return $balance;
    }

    /** Creates one immutable allocation; callers must invoke this only from the Model B workflow. */
    public function allocate(int $dnId, int $targetManifestId, float $quantity, string $unit, string $key): array
    {
        if (!$this->ready()) throw new HttpError(503, 'Fondasi Model B belum diaktifkan pada database ini.');
        if (!preg_match('/^[a-f0-9]{64}$/D', $key)) throw new HttpError(422, 'Token permintaan tidak valid.');
        return Database::transaction($this->data->repo->db, function () use ($dnId, $targetManifestId, $quantity, $unit, $key): array {
            $prior = $this->data->repo->one('SELECT id FROM exp_manifest_allocations WHERE idempotency_key=? FOR UPDATE', [$key]);
            if ($prior) return ['id'=>(int)$prior['id']];
            $dn = $this->data->find('dn', $dnId, true);
            $target = $this->data->find('manifest', $targetManifestId, true);
            if ($target['status'] !== 'draft') throw new HttpError(409, 'Manifest tujuan harus draf.');
            $membership = $this->data->repo->one('SELECT i.manifest_id,m.origin_branch_id FROM exp_manifest_items i JOIN exp_manifests m ON m.id=i.manifest_id WHERE i.dn_id=? AND i.removed_at IS NULL FOR UPDATE', [$dnId]);
            $sourceManifest = $membership ? (int)$membership['manifest_id'] : null;
            $sourceBranch = $membership ? (int)$membership['origin_branch_id'] : (int)$dn['current_branch_id'];
            $sourceLocation = (int)$dn['current_location_id'];
            $targetLocation = $this->data->repo->one('SELECT origin_location_id FROM exp_trip_legs WHERE manifest_id=? ORDER BY position LIMIT 1 FOR UPDATE', [$targetManifestId]);
            if (!$targetLocation) throw new HttpError(409, 'Manifest tujuan belum memiliki lintasan.');
            if (!$membership && $sourceLocation !== (int)$targetLocation['origin_location_id']) throw new HttpError(409, 'Alokasi awal harus berasal dari lokasi DN saat ini.');
            if ($membership && !$this->data->repo->one("SELECT id FROM exp_manifest_allocations WHERE dn_id=? AND source_manifest_id=? AND status IN ('ARRIVED','RECEIVED') LIMIT 1 FOR UPDATE", [$dnId,$sourceManifest])) throw new HttpError(409, 'Muatan belum diterima di lokasi transit.');
            if ($sourceLocation !== (int)$targetLocation['origin_location_id']) throw new HttpError(409, 'Lokasi Manifest tujuan tidak sesuai lokasi transit.');
            if ($membership) {
                $available=(float)($this->data->repo->one("SELECT COALESCE(SUM(a.quantity),0)-COALESCE(SUM((SELECT SUM(rl.quantity_received+rl.quantity_short+rl.quantity_damaged) FROM exp_receipt_lines rl WHERE rl.allocation_id=a.id)),0)-COALESCE(SUM((SELECT SUM(c.quantity) FROM exp_manifest_allocations c WHERE c.source_manifest_id=a.target_manifest_id AND c.dn_id=a.dn_id AND c.status IN ('ALLOCATED','LOADED','IN_TRANSIT','ARRIVED','RECEIVED','CLOSED'))),0) available FROM exp_manifest_allocations a WHERE a.dn_id=? AND a.target_manifest_id=? AND a.status IN ('ARRIVED','IN_TRANSIT','RECEIVED') FOR UPDATE",[$dnId,$sourceManifest])['available']??0);
                if($quantity>$available+0.000001)throw new HttpError(409,'Quantity melebihi saldo transit Manifest sumber.');
            } else $this->assertQuantity($dnId,$quantity,$unit,true);
            $stmt = $this->data->repo->run('INSERT INTO exp_manifest_allocations(dn_id,source_manifest_id,target_manifest_id,quantity,unit,source_branch_id,source_location_id,target_branch_id,target_location_id,status,idempotency_key,created_by) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)', [$dnId,$sourceManifest,$targetManifestId,$quantity,$unit,$sourceBranch,$sourceLocation,(int)$target['origin_branch_id'],(int)$targetLocation['origin_location_id'],'ALLOCATED',$key,$this->data->guard->access->user['id']]);
            return ['id'=>(int)$this->data->repo->db->lastInsertId()];
        });
    }
}
