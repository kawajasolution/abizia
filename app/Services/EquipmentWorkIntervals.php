<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Http\Input;

/** Pure validation; integer seconds/minutes, never a financial calculation. */
final class EquipmentWorkIntervals
{
    public static function parse(array $input):array
    {
        $rows=$input['entries']??null;
        if(!is_array($rows)||!$rows||count($rows)>100)throw new HttpError(422,'Isi 1 sampai 100 interval kerja.');
        $entries=[];$seconds=0;
        foreach($rows as $row){
            if(!is_array($row))throw new HttpError(422,'Format interval tidak sah.');
            $start=EquipmentContracts::time(Input::text($row,'starts_at',19));$end=EquipmentContracts::time(Input::text($row,'ends_at_exclusive',19));
            $break=Input::text($row,'break_minutes',8,false);if($break==='')$break='0';
            if(!ctype_digit($break))throw new HttpError(422,'Istirahat harus menit bulat nonnegatif.');
            $duration=strtotime($end)-strtotime($start);
            if($duration<=0||(int)$break*60>$duration)throw new HttpError(422,'Akhir harus sesudah awal dan istirahat tidak melebihi interval.');
            $entries[]=['starts_at'=>$start,'ends_at_exclusive'=>$end,'break_minutes'=>(int)$break,'activity_note'=>Input::text($row,'activity_note',2000,false)];$seconds+=$duration-(int)$break*60;
        }
        usort($entries,fn($a,$b)=>strcmp($a['starts_at'],$b['starts_at']));
        foreach($entries as $i=>$entry)if($i&&$entry['starts_at']<$entries[$i-1]['ends_at_exclusive'])throw new HttpError(422,'Interval kerja dalam timesheet bertabrakan.');
        $hm=[];foreach(['hm_start','hm_end'] as $field){$v=Input::text($input,$field,13,false);if($v!==''&&!preg_match('/^(?:0|[1-9][0-9]{0,8})(?:\.[0-9]{1,3})?$/D',$v))throw new HttpError(422,'HM harus nonnegatif dengan maksimal tiga desimal.');$hm[$field]=$v===''?null:number_format((float)$v,3,'.','');}
        if(($hm['hm_start']===null)!==($hm['hm_end']===null)||($hm['hm_start']!==null&&(float)$hm['hm_end']<(float)$hm['hm_start']))throw new HttpError(422,'HM wajib berpasangan dan pembacaan normal tidak menurun.');
        return $hm+['entries'=>$entries,'net_seconds'=>$seconds,'work_note'=>Input::text($input,'work_note',2000,false)];
    }
}
