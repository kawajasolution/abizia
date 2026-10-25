<?php use Hls\Http\View as V; ?>
<section class="panel" <?= isset($id) ? 'id="' . V::escape($id) . '"' : '' ?>><?php if (isset($heading)): ?><div class="panel-heading"><h2><?= V::escape($heading) ?></h2></div><?php endif ?><?= $body ?></section>
