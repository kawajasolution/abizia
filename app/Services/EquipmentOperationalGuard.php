<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Repositories\Repository;
final class EquipmentOperationalGuard {
 public static function assertAvailable(Repository $repo,int $asset,bool $lock=true):void { $row=$repo->one('SELECT id,reason FROM eq_unit_holds WHERE asset_id=? AND released_at IS NULL ORDER BY id FOR UPDATE',[$asset]); if($row) throw new HttpError(409,'Unit sedang HOLD P2H: '.(string)$row['reason']); }
}
