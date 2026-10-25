<?php use Hls\Http\View as V; ?>
<form class="panel narrow" method="post" action="<?= V::escape($this->url('/login')) ?>"><?= $this->csrf() ?>
<?= $this->component('field',['name'=>'email','label'=>'Email','type'=>'email','required'=>true,'max'=>190,'autocomplete'=>'username']) ?>
<?= $this->component('field',['name'=>'password','label'=>'Password','type'=>'password','required'=>true,'max'=>72,'autocomplete'=>'current-password']) ?>
<button class="primary" type="submit">Masuk</button></form>