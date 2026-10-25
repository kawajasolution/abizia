<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Repositories\ExpeditionRepository;
use Hls\Repositories\TruckingRepository;
final class TruckingOperations
{
    public readonly TruckingRepository $records;
    public readonly OperationalWrite $write;
    public function __construct(public readonly ExpeditionRepository $data,Audit $audit){$this->records=new TruckingRepository($data);$this->write=new OperationalWrite($data,$audit);}
    private function version(array $row,int $version): void {if((int)$row['version']!==$version)throw new HttpError(409,'Versi telah berubah. Muat ulang.');}
    private function active(string $table,int $id): array
    {
        if(!in_array($table,['md_routes','md_locations','branches','md_assets','md_personnel','md_customers','md_parties'],true))throw new \LogicException('Referensi tidak dikenal.');
        $r=$this->data->repo->one("SELECT * FROM $table WHERE id=? FOR UPDATE",[$id]);if(!$r||!$r['active'])throw new HttpError(422,'Referensi operasional tidak aktif.');return $r;
    }
    private function fleet(array $m): void
    {
        if(!$m['vehicle_id'])throw new HttpError(409,'Kendaraan wajib ditetapkan sebelum konfirmasi/keberangkatan.');
        $v=$this->active('md_assets',(int)$m['vehicle_id']);if($v['kind']!=='truck'||(int)$v['branch_id']!==(int)$m['origin_branch_id'])throw new HttpError(422,'Kendaraan tidak sesuai cabang/jenis.');
        if($m['driver_id']){$d=$this->active('md_personnel',(int)$m['driver_id']);if($d['kind']!=='driver'||(int)$d['branch_id']!==(int)$m['origin_branch_id'])throw new HttpError(422,'Driver tidak sesuai cabang/jenis.');
            if($d['account_id']){$u=$this->data->repo->one('SELECT active,all_branches FROM users WHERE id=? FOR UPDATE',[$d['account_id']]);if(!$u||!$u['active']||(!$u['all_branches']&&!$this->data->repo->one('SELECT 1 FROM user_branches WHERE user_id=? AND branch_id=? FOR UPDATE',[$d['account_id'],$m['origin_branch_id']])))throw new HttpError(422,'Akun driver tidak aktif atau akses cabangnya dicabut.');}}
    }
    public function confirmDn(int $id,int $version,string $key): array
    {
        $dn=$this->data->find('dn',$id);
        return $this->write->run('expedition.confirm','dn_confirm',$key,compact('id','version'),(int)$dn['origin_branch_id'],function()use($id,$version):array{
            $d=$this->data->find('dn',$id,true);$this->version($d,$version);if($d['status']!=='created'||$d['official_number'])throw new HttpError(409,'DN bukan draf awal.');
            foreach(['md_routes'=>$d['route_id'],'md_customers'=>$d['customer_id']] as $table=>$ref)$this->active($table,(int)$ref);
            $sender=$this->active('md_parties',(int)$d['sender_id']);
            if(!in_array($sender['party_role'],['sender','both'],true))throw new HttpError(422,'Peran pengirim pada master terkini tidak memenuhi konfirmasi DN.');
            $this->active('md_parties',(int)$d['receiver_id']);
            $this->active('md_locations',(int)$d['current_location_id']);
            $this->active('branches',(int)$d['destination_branch_id']);$this->active('md_locations',$this->records->destination($d));
            $number=(new DocumentNumbers($this->data->repo))->issue('DN',(int)$d['origin_branch_id']);
            $this->data->repo->run("UPDATE exp_dns SET status='confirmed',official_number=?,confirmed_at=NOW(),version=version+1 WHERE id=?",[$number,$id]);
            $this->write->event($id,null,(int)$d['origin_branch_id'],'dn_confirmed',['number'=>$number,'from'=>'created','to'=>'confirmed']);return ['id'=>$id];
        });
    }
    public function appendLeg(int $id,int $routeId,int $version,string $key): array
    {
        $m=$this->data->find('manifest',$id);
        return $this->write->run('expedition.manifest','trip_append',$key,compact('id','routeId','version'),(int)$m['origin_branch_id'],function()use($id,$routeId,$version):array{
            $m=$this->data->find('manifest',$id,true);$this->version($m,$version);if($m['status']!=='draft')throw new HttpError(409,'Lintasan sudah dibekukan.');
            $legs=$this->records->legs($id,true);$last=$legs[count($legs)-1];$route=$this->active('md_routes',$routeId);
            if((int)$last['destination_location_id']!==(int)$route['origin_location_id'])throw new HttpError(422,'Leg harus berkesinambungan pada lokasi yang tepat.');
            $visited=[(int)$legs[0]['origin_location_id'],...array_map(fn($l)=>(int)$l['destination_location_id'],$legs)];
            if(in_array((int)$route['destination_location_id'],$visited,true))throw new HttpError(422,'Lokasi berulang belum didukung dalam satu trip.');
            $lo=$this->active('md_locations',(int)$route['origin_location_id']);$ld=$this->active('md_locations',(int)$route['destination_location_id']);$dest=$this->active('branches',(int)$route['destination_branch_id']);
            $snapshot=json_encode(['route'=>$route['name'],'origin'=>$lo['name'],'destination'=>$ld['name']],JSON_THROW_ON_ERROR);
            $this->data->repo->run('INSERT INTO exp_trip_legs(manifest_id,position,route_id,origin_branch_id,destination_branch_id,origin_location_id,destination_location_id,snapshot) VALUES (?,?,?,?,?,?,?,?)',[$id,count($legs)+1,$routeId,$route['branch_id'],$route['destination_branch_id'],$lo['id'],$ld['id'],$snapshot]);
            $s=json_decode($m['snapshot'],true,512,JSON_THROW_ON_ERROR);$s['destination']=['id'=>$dest['id'],'name'=>$dest['name']];$s['destination_location']=['id'=>$ld['id'],'name'=>$ld['name']];
            $this->data->repo->run('UPDATE exp_manifests SET destination_branch_id=?,snapshot=?,version=version+1 WHERE id=?',[$dest['id'],json_encode($s,JSON_THROW_ON_ERROR),$id]);
            $this->write->event(null,$id,(int)$m['origin_branch_id'],'trip_leg_added',['route_id'=>$routeId,'position'=>count($legs)+1]);return ['id'=>$id];
        });
    }
    private function eligible(array $dn,array $m): bool
    {
        $stop=$this->records->stop($m);$target=$this->records->destinationIndex($m,$this->records->destination($dn));
        return in_array($dn['status'],['created','confirmed','transit'],true)&&(int)$dn['current_location_id']===$stop['location']&&$target!==null&&$target>$stop['position'];
    }
    public function assignVehicle(int $id,int $vehicleId,?int $driverId,int $version,string $key): array
    {
        $m=$this->data->find('manifest',$id);
        return $this->write->run('expedition.manifest','trip_assignment',$key,compact('id','vehicleId','driverId','version'),(int)$m['origin_branch_id'],function()use($id,$vehicleId,$driverId,$version):array{
            $m=$this->data->find('manifest',$id,true);$this->version($m,$version);if($m['status']!=='draft')throw new HttpError(409,'Kendaraan dibekukan setelah konfirmasi; gunakan Manifest baru.');
            $vehicle=$this->active('md_assets',$vehicleId);if($vehicle['kind']!=='truck'||(int)$vehicle['branch_id']!==(int)$m['origin_branch_id'])throw new HttpError(422,'Kendaraan tidak sesuai cabang/jenis.');
            $s=json_decode($m['snapshot'],true,512,JSON_THROW_ON_ERROR);$s['vehicle']=array_intersect_key($vehicle,array_flip(['id','code','name','identity']));unset($s['driver']);
            if($driverId){$driver=$this->active('md_personnel',$driverId);if($driver['kind']!=='driver'||(int)$driver['branch_id']!==(int)$m['origin_branch_id'])throw new HttpError(422,'Driver tidak sesuai cabang/jenis.');
                if($driver['account_id']){$account=$this->data->repo->one('SELECT name,active,all_branches FROM users WHERE id=? FOR UPDATE',[$driver['account_id']]);if(!$account||!$account['active']||(!$account['all_branches']&&!$this->data->repo->one('SELECT 1 FROM user_branches WHERE user_id=? AND branch_id=? FOR UPDATE',[$driver['account_id'],$m['origin_branch_id']])))throw new HttpError(422,'Akun driver tidak aktif atau tidak sesuai cabang.');$driver['name']=$account['name'];}$s['driver']=array_intersect_key($driver,array_flip(['id','code','name']));
            }
            $this->data->repo->run('UPDATE exp_manifests SET vehicle_id=?,driver_id=?,snapshot=?,version=version+1 WHERE id=?',[$vehicleId,$driverId,json_encode($s,JSON_THROW_ON_ERROR),$id]);$this->write->event(null,$id,(int)$m['origin_branch_id'],'trip_assignment_changed',['vehicle_id'=>$vehicleId,'driver_id'=>$driverId]);return ['id'=>$id];
        });
    }
    public function attach(int $id,array $ids,int $version,string $key): array
    {
        if(!$ids||count($ids)>100)throw new HttpError(422,'Pilih 1–100 DN.');foreach($ids as $value)if(!is_string($value)||!ctype_digit($value)||(int)$value<1)throw new HttpError(422,'ID DN tidak valid.');
        $ids=array_map('intval',$ids);if(count($ids)!==count(array_unique($ids)))throw new HttpError(422,'DN dipilih ganda.');sort($ids);$m=$this->data->find('manifest',$id);
        return $this->write->run('expedition.manifest','trip_attach',$key,compact('id','ids','version'),(int)$m['origin_branch_id'],function()use($id,$ids,$version):array{
            $m=$this->data->find('manifest',$id,true);$this->version($m,$version);if($m['status']!=='draft')throw new HttpError(409,'Manifest tujuan harus draf.');
            foreach($this->records->legs($id,true) as $leg)$this->active('md_routes',(int)$leg['route_id']);
            foreach($ids as $dnId){$dn=$this->data->find('dn',$dnId,true);if(!$this->eligible($dn,$m)||$this->data->active($dnId,true))throw new HttpError(409,'Posisi, tujuan lintasan atau keanggotaan DN tidak memenuhi syarat.');
                $this->data->repo->run('INSERT INTO exp_manifest_items(manifest_id,dn_id,attached_by) VALUES (?,?,?)',[$id,$dnId,$this->data->guard->access->user['id']]);$this->data->repo->run('UPDATE exp_dns SET version=version+1 WHERE id=?',[$dnId]);$this->write->event($dnId,$id,(int)$m['origin_branch_id'],'manifest_attached',['manifest_id'=>$id]);
            }
            $this->data->repo->run('UPDATE exp_manifests SET version=version+1 WHERE id=?',[$id]);return ['id'=>$id];
        });
    }
    public function manifest(int $id,string $action,int $version,string $key,array $input=[]): array
    {
        if(!in_array($action,['confirm','depart','arrive','record_arrival','unload','complete','cancel'],true))throw new HttpError(405,'Aksi trip tidak dikenal.');
        $m=$this->data->find('manifest',$id);$branch=$this->records->stop($m,$action==='arrive'&&$m['status']==='departed'?(int)$m['current_stop']+1:null)['branch'];
        $permission=in_array($action,['confirm','cancel'],true)?'expedition.manifest':'expedition.transit';
        $payload=compact('id','action','version')+['dn_ids'=>$input['dn_ids']??[],'dn_id'=>$input['dn_id']??'','note'=>Input::text($input,'note',1000,false)];
        return $this->write->run($permission,'trip_'.$action,$key,$payload,$branch,function()use($id,$action,$version,$payload,$branch):array{
            $m=$this->data->find('manifest',$id,true);$this->version($m,$version);$legs=$this->records->legs($id,true);$stop=$this->records->stop($m);$before=$m['status'];$to=$before;
            $items=$this->data->repo->all('SELECT dn_id FROM exp_manifest_items WHERE manifest_id=? AND removed_at IS NULL ORDER BY dn_id FOR UPDATE',[$id]);
            if($action==='confirm'){
                if($before!=='draft'||!$items||!$m['vehicle_id'])throw new HttpError(409,'Konfirmasi memerlukan draf berisi DN dan kendaraan.');
                $this->fleet($m);
                foreach($legs as $leg){$this->active('md_routes',(int)$leg['route_id']);$this->active('branches',(int)$leg['origin_branch_id']);$this->active('branches',(int)$leg['destination_branch_id']);$this->active('md_locations',(int)$leg['origin_location_id']);$this->active('md_locations',(int)$leg['destination_location_id']);}
                foreach($items as $item){$dn=$this->data->find('dn',(int)$item['dn_id'],true);if(!in_array($dn['status'],['confirmed','transit'],true)||!$this->eligible($dn,$m))throw new HttpError(409,'Seluruh DN harus terkonfirmasi dan sesuai lintasan.');}
                $number=(new DocumentNumbers($this->data->repo))->issue('MF',(int)$m['origin_branch_id']);$this->data->repo->run('UPDATE exp_manifests SET official_number=?,confirmed_at=NOW() WHERE id=?',[$number,$id]);$to='confirmed';
            }elseif($action==='depart'){
                if(!in_array($before,['confirmed','transit'],true)||(!$items&&$before==='confirmed')||(int)$m['current_stop']>=count($legs))throw new HttpError(409,'Trip tidak memenuhi keberangkatan.');
                $this->active('md_locations',$stop['location']);
                $this->fleet($m);$next=$legs[(int)$m['current_stop']];$this->active('md_routes',(int)$next['route_id']);$this->active('branches',(int)$next['destination_branch_id']);$this->active('md_locations',(int)$next['destination_location_id']);
                foreach($items as $item){$dn=$this->data->find('dn',(int)$item['dn_id'],true);if(!in_array($dn['status'],['confirmed','transit'],true)||!$this->eligible($dn,$m))throw new HttpError(409,'Catat kedatangan/penurunan DN sebelum melanjutkan.');$this->data->repo->run("UPDATE exp_dns SET status='departed',version=version+1 WHERE id=?",[$dn['id']]);$this->write->event((int)$dn['id'],$id,$stop['branch'],'dn_departed',['position'=>$stop['position']]);}$to='departed';
            }elseif($action==='arrive'){
                if($before!=='departed'||!isset($legs[(int)$m['current_stop']]))throw new HttpError(409,'Kendaraan belum berangkat pada leg ini.');
                $next=$legs[(int)$m['current_stop']];$this->active('branches',(int)$next['destination_branch_id']);$this->active('md_locations',(int)$next['destination_location_id']);
                $this->data->repo->run('UPDATE exp_trip_legs SET arrived_at=NOW() WHERE id=?',[$next['id']]);$this->data->repo->run('UPDATE exp_manifests SET current_stop=current_stop+1 WHERE id=?',[$id]);$to='transit';
            }elseif($action==='record_arrival'){
                if($before!=='transit')throw new HttpError(409,'Kendaraan belum tiba.');$ids=$payload['dn_ids'];if(!is_array($ids)||!$ids||count($ids)>100)throw new HttpError(422,'Pilih DN yang benar-benar tiba.');
                $seen=[];foreach($ids as $raw){$dnId=Input::id(['id'=>$raw],'id');if(isset($seen[$dnId]))throw new HttpError(422,'DN ganda.');$seen[$dnId]=true;$dn=$this->data->find('dn',$dnId,true);$membership=$this->data->active($dnId,true);if(!$membership||(int)$membership['manifest_id']!==$id||$dn['status']!=='departed')throw new HttpError(409,'DN bukan muatan yang menunggu pencatatan tiba.');
                    $status=$this->records->destination($dn)===$stop['location']?'arrived':'transit';$this->data->repo->run('UPDATE exp_dns SET status=?,current_branch_id=?,current_location_id=?,version=version+1 WHERE id=?',[$status,$stop['branch'],$stop['location'],$dnId]);$this->write->event($dnId,$id,$stop['branch'],'dn_arrival_recorded',['status'=>$status,'location_id'=>$stop['location']]);}
            }elseif($action==='unload'){
                if($before!=='transit'||$payload['note']==='')throw new HttpError(422,'Penurunan memerlukan kendaraan berhenti dan alasan/catatan.');$dnId=Input::id(['id'=>$payload['dn_id']],'id');$dn=$this->data->find('dn',$dnId,true);$membership=$this->data->active($dnId,true);
                if(!$membership||(int)$membership['manifest_id']!==$id||!in_array($dn['status'],['transit','arrived'],true)||(int)$dn['current_location_id']!==$stop['location'])throw new HttpError(409,'DN belum tercatat tiba pada stop ini.');
                $this->remove($membership,$payload['note']);$this->data->repo->run('UPDATE exp_dns SET version=version+1 WHERE id=?',[$dnId]);$this->write->event($dnId,$id,$stop['branch'],'dn_unloaded',['reason'=>$payload['note']]);
            }elseif($action==='complete'){
                if($before!=='transit'||(int)$m['current_stop']!==count($legs)||$items)throw new HttpError(409,'Trip hanya selesai di stop terakhir setelah semua DN diturunkan/dipindah.');$to='completed';
            }else{
                if(!in_array($before,['draft','confirmed'],true)||(int)$m['current_stop']!==0||$items||$payload['note']==='')throw new HttpError(409,'Pembatalan hanya sebelum berangkat, manifest kosong dan alasan wajib.');$to='cancelled';
            }
            $this->data->repo->run('UPDATE exp_manifests SET status=?,version=version+1 WHERE id=?',[$to,$id]);$this->write->event(null,$id,$branch,'trip_'.$action,['from'=>$before,'to'=>$to,'note'=>$payload['note']]);return ['id'=>$id];
        });
    }
    private function remove(array $membership,string $reason,?int $target=null): void
    {
        $this->data->repo->run('UPDATE exp_manifest_items SET removed_at=NOW(),removed_by=?,removal_reason=?,moved_to_manifest_id=? WHERE id=?',[$this->data->guard->access->user['id'],$reason,$target,$membership['id']]);
    }
    public function move(int $dnId,int $target,int $sourceVersion,int $targetVersion,string $reason,string $key): array
    {
        $dn=$this->data->find('dn',$dnId);$reason=Input::text(['note'=>$reason],'note',1000);
        return $this->write->run('expedition.manifest','dn_move',$key,compact('dnId','target','sourceVersion','targetVersion','reason'),(int)$dn['current_branch_id'],function()use($dnId,$target,$sourceVersion,$targetVersion,$reason):array{
            $membership=$this->data->active($dnId,true);if(!$membership||(int)$membership['manifest_id']===$target)throw new HttpError(409,'Manifest asal/tujuan tidak valid.');
            $ids=[(int)$membership['manifest_id'],$target];sort($ids);$locked=[];foreach($ids as $id)$locked[$id]=$this->data->find('manifest',$id,true);
            $source=$locked[(int)$membership['manifest_id']];$m=$locked[$target];$this->version($source,$sourceVersion);$this->version($m,$targetVersion);$dn=$this->data->find('dn',$dnId,true);
            foreach($this->records->legs($target,true) as $leg)$this->active('md_routes',(int)$leg['route_id']);
            if(!in_array($source['status'],['draft','confirmed','transit'],true)||$m['status']!=='draft'||!$this->eligible($dn,$m)||$this->records->stop($source)['location']!==(int)$dn['current_location_id'])throw new HttpError(409,'Pemindahan hanya saat berhenti ke draf pada posisi aktual yang sama.');
            $this->remove($membership,$reason,$target);$this->data->repo->run('INSERT INTO exp_manifest_items(manifest_id,dn_id,attached_by) VALUES (?,?,?)',[$target,$dnId,$this->data->guard->access->user['id']]);
            foreach($ids as $id)$this->data->repo->run('UPDATE exp_manifests SET version=version+1 WHERE id=?',[$id]);$this->data->repo->run('UPDATE exp_dns SET version=version+1 WHERE id=?',[$dnId]);
            $this->write->event($dnId,(int)$source['id'],(int)$dn['current_branch_id'],'dn_moved',['from'=>$source['id'],'to'=>$target,'reason'=>$reason]);$this->write->event(null,$target,(int)$dn['current_branch_id'],'dn_move_received',['dn_id'=>$dnId,'from'=>$source['id'],'reason'=>$reason]);return ['id'=>$target];
        });
    }
    public function receive(int $id,int $version,string $key,array $input,bool $finish=false): array
    {
        $dn=$this->data->find('dn',$id);$recipient=$finish?'':Input::text($input,'recipient_name',150);$note=Input::text($input,'condition_note',1000,!$finish);
        if(!$finish&&Input::flag($input,'whole_confirm')!==1)throw new HttpError(422,'Penerimaan harus utuh dan sesuai. Selisih dicatat sebagai klaim.');
        return $this->write->run('expedition.receive',$finish?'dn_finish':'dn_receive',$key,compact('id','version','recipient','note','finish'),(int)$dn['destination_branch_id'],function()use($id,$version,$recipient,$note,$finish):array{
            $d=$this->data->find('dn',$id,true);$this->version($d,$version);
            if($this->data->active($id,true)||(int)$d['current_location_id']!==$this->records->destination($d)||$d['status']!==($finish?'received':'arrived'))throw new HttpError(409,'DN belum memenuhi penerimaan/penyelesaian aktual.');
            if(!$finish){$this->data->repo->run('INSERT INTO exp_receipts(dn_id,branch_id,actor_id,recipient_name,quantity,condition_note) VALUES (?,?,?,?,?,?)',[$id,$d['destination_branch_id'],$this->data->guard->access->user['id'],$recipient,$d['quantity'],$note]);}
            elseif(!$this->data->repo->one('SELECT id FROM exp_receipts WHERE dn_id=? FOR UPDATE',[$id]))throw new HttpError(409,'Tidak ada record penerimaan aktual.');
            $status=$finish?'completed':'received';$this->data->repo->run('UPDATE exp_dns SET status=?,version=version+1 WHERE id=?',[$status,$id]);$this->write->event($id,null,(int)$d['destination_branch_id'],$finish?'dn_completed':'dn_received',['recipient'=>$recipient,'condition_note'=>$note,'status'=>$status]);return ['id'=>$id];
        });
    }
}
