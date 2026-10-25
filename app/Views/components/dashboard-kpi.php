<?php use Hls\Http\View as V; use Hls\Http\Icons; ?>
<article class="panel kpi-card" data-kpi="<?= V::escape($metric['id']) ?>"><div class="kpi-label"><?= Icons::svg($metric['icon']) ?><h3><?= V::escape($metric['label']) ?></h3></div><strong class="kpi-value"><?= (int)$metric['value'] ?></strong><p><?= V::escape($metric['note']) ?></p></article>
