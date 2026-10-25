<?php
declare(strict_types=1);
namespace Hls\Services;

use Hls\Http\HttpError;
use Hls\Database;
use Hls\Repositories\ExpeditionRepository;

/** Read-side adapter for Model B; feature-gated until migration 038 is approved. */
final class ManifestModelB
{
    public function __construct(private readonly ExpeditionRepository $data, private readonly ManifestAllocation $allocation) {}

    public function enabled(): bool { return $this->allocation->ready() && getenv('HLS_MODEL_B_ENABLED') === '1'; }

    public function transitBalance(int $dnId): array
    {
        if (!$this->enabled()) throw new HttpError(503, 'Model B belum diaktifkan.');
        $this->data->find('dn', $dnId);
        $rows = $this->data->repo->all("SELECT a.id,a.quantity,COALESCE((SELECT SUM(rl.quantity_received+rl.quantity_short+rl.quantity_damaged) FROM exp_receipt_lines rl WHERE rl.allocation_id=a.id),0) received,COALESCE((SELECT SUM(c.quantity) FROM exp_manifest_allocations c WHERE c.source_manifest_id=a.target_manifest_id AND c.dn_id=a.dn_id AND c.status IN ('ALLOCATED','LOADED','IN_TRANSIT','ARRIVED','RECEIVED','CLOSED')),0) forwarded FROM exp_manifest_allocations a WHERE a.dn_id=? AND a.status IN ('ARRIVED','IN_TRANSIT','RECEIVED')", [$dnId]);
        $allocated=$received=$available=0.0;foreach($rows as $row){$allocated+=(float)$row['quantity'];$received+=(float)$row['received'];$available+=max(0.0,(float)$row['quantity']-(float)$row['received']-(float)$row['forwarded']);}
        return ['allocated'=>$allocated,'received'=>$received,'available'=>$available];
    }

    public function tracking(int $dnId): array
    {
        if (!$this->enabled()) throw new HttpError(503, 'Model B belum diaktifkan.');
        $this->data->find('dn', $dnId);
        return $this->data->repo->all("SELECT a.id,a.quantity,a.unit,a.status,a.source_manifest_id,a.target_manifest_id,a.created_at,sm.number source_number,tm.number target_number FROM exp_manifest_allocations a LEFT JOIN exp_manifests sm ON sm.id=a.source_manifest_id JOIN exp_manifests tm ON tm.id=a.target_manifest_id WHERE a.dn_id=? ORDER BY a.id", [$dnId]);
    }

    public function targets(int $branchId, int $locationId, int $excludeManifestId): array
    {
        if (!$this->enabled()) return [];
        $actor=$this->data->guard->access->user;
        $scope=$actor['all_branches']?'1=1':'EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=? AND ub.branch_id=m.origin_branch_id)';
        $args=$actor['all_branches']?[]:[$actor['id']];
        return $this->data->repo->all("SELECT m.id,m.number,m.vehicle_id,m.driver_id,m.origin_branch_id,m.destination_branch_id,v.name vehicle_name,COALESCE(u.name,p.name) driver_name,lo.name origin_name,ld.name destination_name FROM exp_manifests m JOIN exp_trip_legs l ON l.manifest_id=m.id AND l.position=1 JOIN md_locations lo ON lo.id=l.origin_location_id JOIN md_locations ld ON ld.id=l.destination_location_id LEFT JOIN md_assets v ON v.id=m.vehicle_id LEFT JOIN md_personnel p ON p.id=m.driver_id LEFT JOIN users u ON u.id=p.account_id WHERE m.status='draft' AND m.id<>? AND m.origin_branch_id=? AND l.origin_location_id=? AND m.vehicle_id IS NOT NULL AND v.active=1 AND (m.driver_id IS NULL OR p.active=1) AND $scope ORDER BY m.id DESC",[$excludeManifestId,$branchId,$locationId,...$args]);
    }

    public function receive(int $allocationId, float $received, float $short, float $damaged, string $note, string $key): array
    {
        if (!$this->enabled()) throw new HttpError(503, 'Model B belum diaktifkan.');
        if (!preg_match('/^[a-f0-9]{64}$/D', $key) || $received <= 0 || $short < 0 || $damaged < 0) throw new HttpError(422, 'Data penerimaan tidak valid.');
        return Database::transaction($this->data->repo->db, function () use ($allocationId,$received,$short,$damaged,$note,$key): array {
            $prior=$this->data->repo->one('SELECT id FROM exp_receipt_lines WHERE idempotency_key=? FOR UPDATE',[$key]);
            if($prior)return ['id'=>(int)$prior['id']];
            $a=$this->data->repo->one("SELECT * FROM exp_manifest_allocations WHERE id=? FOR UPDATE",[$allocationId]);
            if(!$a||in_array($a['status'],['RECEIVED','CLOSED'],true))throw new HttpError(409,'Alokasi tidak tersedia untuk penerimaan.');
            $used=(float)($this->data->repo->one('SELECT COALESCE(SUM(quantity_received+quantity_short+quantity_damaged),0) total FROM exp_receipt_lines WHERE allocation_id=? FOR UPDATE',[$allocationId])['total']??0);
            if($received+$short+$damaged > (float)$a['quantity']-$used+0.000001)throw new HttpError(409,'Penerimaan melebihi quantity alokasi.');
            $r=$this->data->repo->one('SELECT id FROM exp_receipts WHERE dn_id=? FOR UPDATE',[$a['dn_id']]);
            if(!$r){$dn=$this->data->find('dn',(int)$a['dn_id'],true);$this->data->repo->run('INSERT INTO exp_receipts(dn_id,branch_id,actor_id,recipient_name,quantity,condition_note) VALUES (?,?,?,?,?,?)',[$a['dn_id'],$dn['destination_branch_id'],$this->data->guard->access->user['id'],'Model B',$a['quantity'],$note]);$r=['id'=>(int)$this->data->repo->db->lastInsertId()];}
            $this->data->repo->run('INSERT INTO exp_receipt_lines(receipt_id,allocation_id,quantity_received,quantity_short,quantity_damaged,condition_note,exception_reason,received_by,idempotency_key) VALUES (?,?,?,?,?,?,?,?,?)',[$r['id'],$allocationId,$received,$short,$damaged,$note,$short||$damaged?$note:null,$this->data->guard->access->user['id'],$key]);
            $lineId=(int)$this->data->repo->db->lastInsertId();$newUsed=$used+$received+$short+$damaged;$status=$newUsed+0.000001 >= (float)$a['quantity']?'RECEIVED':'ARRIVED';
            $this->data->repo->run('UPDATE exp_manifest_allocations SET status=? WHERE id=?',[$status,$allocationId]);
            return ['id'=>$lineId,'status'=>$status];
        });
    }
}
