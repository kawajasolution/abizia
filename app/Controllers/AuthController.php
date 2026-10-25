<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\Input;
use Hls\Http\View;
use Hls\Services\Auth;
final class AuthController
{
    public function __construct(private Auth $auth, private View $view, private ?array $user) {}
    public function form(): void { if ($this->user) $this->view->redirect('/'); $this->view->render('login', ['title' => 'Masuk']); }
    public function login(): void
    {
        $password = $_POST['password'] ?? ''; if (!is_string($password)) throw new \Hls\Http\HttpError(422, 'Password tidak valid.');
        $this->auth->login(Input::text($_POST, 'email', 190), $password, $_SERVER['REMOTE_ADDR'] ?? 'unknown');
        $this->view->redirect('/');
    }
    public function logout(): void { $this->auth->logout($this->user); $this->view->redirect('/login'); }
}
