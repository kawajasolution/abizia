<?php use Hls\Http\View as V; use Hls\Http\Icons; ?>
<aside class="sidebar" id="primary-sidebar" aria-label="Navigasi aplikasi">
<div class="sidebar-brand"><a class="brand" href="<?= V::escape($this->url('/')) ?>" aria-label="HLS Transport V2"><img src="<?= V::escape($this->url('/assets/images/logo.png')) ?>" width="2170" height="725" alt="HLS — Hanqia Lintas Sarana"></a><button class="icon-button drawer-close" type="button" data-drawer-close aria-label="Tutup navigasi"><?= Icons::svg('close') ?></button></div>
<nav class="primary-navigation" aria-label="Navigasi utama">
<?php foreach ($groups as $label => $items): ?>
<?php if ($label === 'Dashboard'): $item = $items[0]; ?>
<a class="nav-link nav-direct <?= $this->path() === $item['route'] ? 'is-active' : '' ?>" data-nav-id="<?= V::escape($item['id']) ?>" href="<?= V::escape($this->url($item['route'])) ?>" <?= $this->path() === $item['route'] ? 'aria-current="page"' : '' ?>><?= Icons::svg($item['icon']) ?><span><?= V::escape($item['label']) ?></span></a>
<?php else: $isOpen = (bool)array_filter($items, fn($item) => !empty($item['route']) && $this->path() === $item['route']); $displayLabel = $label === 'Gudang & Inventori' ? 'Inventory' : $label; ?>
<details class="nav-group" <?= $isOpen ? 'open' : '' ?>><summary><?= Icons::svg($label === 'Master Data' ? 'building' : 'shield') ?><span><?= V::escape($displayLabel) ?></span><?= Icons::svg('chevron') ?></summary><div class="nav-group-items">
<?php foreach ($items as $item): ?><?php if (!empty($item['placeholder'])): ?><span class="nav-link nav-placeholder" aria-disabled="true"><?= Icons::svg($item['icon']) ?><span><?= V::escape($item['label']) ?></span></span><?php else: ?><a class="nav-link <?= $this->path() === $item['route'] ? 'is-active' : '' ?>" data-nav-id="<?= V::escape($item['id']) ?>" href="<?= V::escape($this->url($item['route'])) ?>" <?= $this->path() === $item['route'] ? 'aria-current="page"' : '' ?>><?= Icons::svg($item['icon']) ?><span><?= V::escape($item['label']) ?></span></a><?php endif ?><?php endforeach ?>
</div></details>
<?php endif ?>
<?php endforeach ?>
</nav><div class="sidebar-context"><span class="context-label">Cakupan akses</span><strong><?= $access->user['all_branches'] ? 'Seluruh cabang' : 'Cabang yang ditetapkan' ?></strong><span><?= V::escape($access->user['role_name']) ?></span></div>
</aside>
