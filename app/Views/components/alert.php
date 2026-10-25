<?php use Hls\Http\View as V; use Hls\Http\Icons; $kind = ($kind ?? '') === 'success' ? 'success' : 'error'; ?>
<div class="alert <?= $kind ?>" role="<?= $kind === 'error' ? 'alert' : 'status' ?>"><?= Icons::svg($kind === 'error' ? 'alert' : 'check') ?><p><?= V::escape($message) ?></p></div>
