<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Repositories\Repository;
final class MasterPermissions
{
    public static function seed(Repository $repo,array $catalog):void
    {
        $read=[
          'Admin Pengirim'=>['customers','parties','locations','routes','trucking-tariffs','vehicles','drivers'],
          'Admin Transit'=>['parties','locations','routes','vehicles','drivers'],
          'Admin Penerima'=>['customers','parties','locations','routes'],
          'Admin Sewa'=>['customers','units','operators','equipment-tariffs'],
          'Operator Alat Berat'=>['units'], 'Finance'=>['customers','suppliers'],
          'Gudang'=>['items','categories','uoms','suppliers','units'],
        ];
        $grant=static function(string $role,string $code,string $label)use($repo):void{
            $repo->run('INSERT IGNORE INTO permissions(code,name) VALUES (?,?)',[$code,$label]);
            $repo->run('INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name=? AND p.code=?',[$role,$code]);
        };
        foreach($catalog['entities'] as $key=>$entity){
            if($key==='branches'){ $grant('Owner','branches.view','Lihat cabang sesuai cakupan');continue; }
            foreach(['view'=>'Lihat','create'=>'Tambah','update'=>'Ubah'] as $action=>$verb)$grant('Administrator',$entity['permission'].'.'.$action,$verb.' master '.$entity['label']);
            $grant('Owner',$entity['permission'].'.view','Lihat master '.$entity['label']);
            foreach($read as $role=>$keys)if(in_array($key,$keys,true))$grant($role,$entity['permission'].'.view','Lihat master '.$entity['label']);
        }
        foreach($catalog['groups'] as $group){
            $grant('Administrator',$group['permission'],'Lihat '.$group['label']);
            $grant('Owner',$group['permission'],'Lihat '.$group['label']);
            foreach($read as $role=>$keys)if(array_intersect($keys,$group['tabs']))$grant($role,$group['permission'],'Lihat '.$group['label']);
        }
    }
}
