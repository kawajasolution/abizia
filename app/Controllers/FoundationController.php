<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\Input;
use Hls\Http\View;
use Hls\Http\HttpError;
use Hls\Http\Pagination;
use Hls\Middleware\Access;
use Hls\Repositories\Repository;
use Hls\Repositories\UserRepository;
use Hls\Services\MasterService;
final class FoundationController
{
    public function __construct(private Repository $repo, private UserRepository $usersRepo, private Access $access, private MasterService $master, private View $view) {}
    private function visibleBranches(): array
    {
        return $this->access->user['all_branches'] ? $this->repo->all('SELECT * FROM branches ORDER BY name') : $this->repo->all('SELECT b.* FROM branches b JOIN user_branches ub ON ub.branch_id=b.id WHERE ub.user_id=? ORDER BY b.name', [$this->access->user['id']]);
    }
    public function users(?array $old = null, ?string $formError = null): void
    {
        $this->access->global(); $id = Input::id($_GET, 'edit', true); $edit = $id ? $this->usersRepo->find($id) : null;
        if ($id) { $this->access->demand('users.manage'); if (!$edit) throw new HttpError(404, 'Pengguna tidak ditemukan.'); }
        $selected = $edit ? $this->usersRepo->branches($id) : [];
        if ($old !== null) { $edit = $this->safeOld($old, ['id','name','email','role_id','active','all_branches']); $selected = array_map('intval', array_filter(is_array($old['branches'] ?? null) ? $old['branches'] : [], 'is_string')); }
        $this->view->render('users', ['title' => 'Pengguna', 'roles' => $this->repo->all('SELECT * FROM roles ORDER BY id'), 'branches' => $this->visibleBranches(), 'edit' => $edit, 'selected' => $selected, 'formError' => $formError] + Pagination::slice($this->usersRepo->listing(), $_GET));
    }
    public function saveUser(): void { $this->save(fn() => $this->master->user($_POST), 'users'); }
    public function roles(): void
    {
        $this->access->global();
        $this->view->render('roles', ['title' => 'Role & Hak Akses'] + Pagination::slice($this->repo->all('SELECT r.name,p.code,p.name AS permission_name FROM roles r JOIN role_permissions rp ON rp.role_id=r.id JOIN permissions p ON p.id=rp.permission_id ORDER BY r.id,p.code'), $_GET));
    }
    public function audit(): void
    {
        $this->access->global();
        $this->view->render('audit', ['title' => 'Audit Log'] + Pagination::slice($this->repo->all('SELECT a.id,a.action,a.entity,a.entity_id,a.detail,a.created_at,u.name AS actor FROM audit_logs a LEFT JOIN users u ON u.id=a.actor_id ORDER BY a.id DESC LIMIT 100'), $_GET));
    }
    private function safeOld(array $old, array $keys): array
    {
        $safe = []; foreach ($keys as $key) $safe[$key] = is_string($old[$key] ?? null) ? $old[$key] : '';
        return $safe;
    }
    private function save(callable $work, string $page): void
    {
        try { $work(); }
        catch (HttpError $error) { if ($error->status !== 422) throw $error; http_response_code(422); $this->$page($_POST, $error->getMessage()); return; }
        catch (\PDOException $error) { if ($error->getCode() !== '23000') throw $error; http_response_code(409); $this->$page($_POST, 'Kode atau email sudah digunakan. Periksa isian Anda.'); return; }
        $_SESSION['flash'] = $page === 'users' ? 'Pengguna disimpan.' : 'Cabang disimpan.';
        $this->view->redirect('/' . $page);
    }
}
