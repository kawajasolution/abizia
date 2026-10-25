<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\View;
use Hls\Services\Dashboard;
final class DashboardController
{
    public function __construct(private Dashboard $dashboard,private View $view) {}
    public function show(): void { $this->view->render('dashboard',['title'=>'Executive Dashboard','dashboard'=>$this->dashboard->build($_GET)]); }
}
