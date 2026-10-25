<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Repositories\Repository;
final class DocumentNumbers
{
    public function __construct(private Repository $repo) {}
    public function issue(string $type,int $branch): string
    {
        if(!$this->repo->db->inTransaction())throw new \LogicException('Penomoran harus dalam transaksi konfirmasi.');
        if(!in_array($type,['DN','MF'],true))throw new \LogicException('Jenis dokumen di luar Tahap 5.');
        $b=$this->repo->one('SELECT code,active FROM branches WHERE id=? FOR UPDATE',[$branch]);
        if(!$b||!$b['active'])throw new HttpError(422,'Cabang penomoran tidak aktif.');
        $year=(int)date('Y');
        $this->repo->run('INSERT INTO exp_sequences(document_type,branch_id,document_year,last_value) VALUES (?,?,?,0) ON DUPLICATE KEY UPDATE last_value=last_value',[$type,$branch,$year]);
        $row=$this->repo->one('SELECT last_value FROM exp_sequences WHERE document_type=? AND branch_id=? AND document_year=? FOR UPDATE',[$type,$branch,$year]);
        $next=(int)$row['last_value']+1;if($next>999999)throw new HttpError(409,'Nomor tahun ini telah mencapai batas enam digit.');
        $this->repo->run('UPDATE exp_sequences SET last_value=? WHERE document_type=? AND branch_id=? AND document_year=?',[$next,$type,$branch,$year]);
        return $type.'/'.$b['code'].'/'.$year.'/'.str_pad((string)$next,6,'0',STR_PAD_LEFT);
    }
}
