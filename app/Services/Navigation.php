<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Middleware\Access;
final class Navigation
{
    public function __construct(private array $items, private array $routes) {}
    public function visible(Access $access): array
    {
        return array_values(array_filter($this->items, fn(array $item): bool => $item['available'] && is_string($item['route']) && isset($this->routes[$item['route']]['GET']) && $this->routes[$item['route']]['GET'][2] === $item['permission'] && $access->can($item['permission']) && (!$item['global'] || $access->user['all_branches'])));
    }
    public function groups(Access $access): array
    {
        $groups = [];
        foreach (['Dashboard','Trucking','Equipment','Keuangan','Gudang & Inventori','Laporan','Master Data'] as $group) $groups[$group] = [];
        foreach ($this->visible($access) as $item) $groups[$item['group']][] = $item;
        $planned = ['Keuangan'=>['Dashboard Keuangan','Invoice','Pembayaran','Piutang','Utang','Kas & Bank','Pengeluaran','Laba/Rugi'],'Gudang & Inventori'=>['Stok Barang','Barang Masuk','Barang Keluar','Mutasi Stok','Laporan Persediaan'],'Laporan'=>['Laporan Operasional','Laporan Keuangan','Laporan per Cabang']];
        foreach ($planned as $group=>$labels) { $existing=array_map(fn($i)=>(string)$i['label'],$groups[$group]); foreach ($labels as $label) if(!in_array($label,$existing,true)) $groups[$group][] = ['id'=>'planned-'.count($groups[$group]),'label'=>$label,'route'=>null,'icon'=>'lock','group'=>$group,'permission'=>'','global'=>false,'shortcuts'=>[],'available'=>false,'placeholder'=>true]; }
        if (!$groups['Dashboard']) unset($groups['Dashboard']);
        if (!$groups['Master Data']) unset($groups['Master Data']);
        return $groups;
    }
    public function shortcuts(Access $access): array
    {
        $items = [];
        foreach ($this->visible($access) as $item) {
            $rank = $item['shortcuts'][$access->user['role_name']] ?? $item['shortcuts']['*'] ?? null;
            if ($rank !== null) $items[] = $item + ['rank' => $rank];
        }
        usort($items, static fn($a, $b) => $a['rank'] <=> $b['rank']);
        return array_slice($items, 0, 5);
    }
}
