<?php use Hls\Http\View as V; use Hls\Http\Icons; ?>
<div class="empty-state"><?= Icons::svg('document') ?><strong><?= V::escape($heading ?? 'Belum ada data') ?></strong><p><?= V::escape($message ?? 'Data yang dicatat akan tampil di sini.') ?></p></div>
