<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Database;
use Hls\Http\Input;
use Hls\Http\HttpError;
use Hls\Middleware\Access;
use Hls\Repositories\Repository;
final class MasterService
{
    public function __construct(private Repository $repo, private Access $access, private Audit $audit) {}
    public function branch(array $data): int
    {
        // Compatibility for internal foundation callers. HTTP uses MasterDataController
        // and requires the submitted optimistic version for every edit.
        if (!empty($data['id'])) {
            $this->access->demandBranch((int)$data['id']);
            $record=$this->repo->one('SELECT * FROM branches WHERE id=?',[(int)$data['id']]);
            if ($record) foreach (['version','city','province','phone'] as $field) if (!isset($data[$field])) $data[$field]=(string)$record[$field];
        }
        return (new MasterData(new \Hls\Repositories\MasterDataRepository($this->repo,$this->access,require dirname(__DIR__).'/master-data.php'),$this->audit))->save('branches',$data);
    }
    public function user(array $data): int
    {
        $this->access->demand('users.manage'); $this->access->global(); $id = Input::id($data, 'id', true);
        if ($id === (int)$this->access->user['id']) throw new HttpError(403, 'Akun sendiri tidak dapat diubah melalui master.');
        $name = Input::text($data, 'name', 100); $email = strtolower(Input::text($data, 'email', 190)); $role = Input::id($data, 'role_id');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) throw new HttpError(422, 'Email tidak valid.');
        $active = Input::flag($data, 'active'); $all = Input::flag($data, 'all_branches');
        $password = $data['password'] ?? ''; if (!is_string($password)) throw new HttpError(422, 'Password tidak valid.');
        $hash = $password !== '' ? Input::password($password) : null;
        if (!$id && !$hash) throw new HttpError(422, 'Password wajib untuk pengguna baru.');
        $branches = $data['branches'] ?? [];
        if (!is_array($branches) || count($branches) > 500) throw new HttpError(422, 'Pilihan cabang tidak valid.');
        $branches = array_values(array_unique(array_map(static fn($b) => Input::id(['branch' => $b], 'branch'), $branches)));
        if (!$all && !$branches) throw new HttpError(422, 'Pilih minimal satu cabang.');
        return Database::transaction($this->repo->db, function () use ($id, $name, $email, $role, $active, $all, $hash, $branches): int {
            // Serialize administrator lifecycle changes, including last-admin protection.
            $this->repo->all("SELECT u.id FROM users u JOIN roles r ON r.id=u.role_id WHERE r.name='Administrator' AND u.all_branches=1 AND u.active=1 ORDER BY u.id FOR UPDATE");
            if (!$this->repo->one('SELECT id FROM roles WHERE id=?', [$role])) throw new HttpError(422, 'Role tidak tersedia.');
            foreach ($branches as $branch) if (!$this->repo->one('SELECT id FROM branches WHERE id=? AND active=1', [$branch])) throw new HttpError(422, 'Cabang tidak aktif atau tidak tersedia.');
            $before = $id ? $this->repo->one('SELECT id,name,email,role_id,active,all_branches FROM users WHERE id=? FOR UPDATE', [$id]) : null;
            if ($id && !$before) throw new HttpError(404, 'Pengguna tidak ditemukan.');
            if ($id) {
                $this->repo->run('UPDATE users SET name=?,email=?,role_id=?,active=?,all_branches=?,auth_version=auth_version+1 WHERE id=?', [$name, $email, $role, $active, $all, $id]);
                if ($hash) $this->repo->run('UPDATE users SET password_hash=? WHERE id=?', [$hash, $id]);
            } else { $this->repo->run('INSERT INTO users(name,email,password_hash,role_id,active,all_branches) VALUES (?,?,?,?,?,?)', [$name, $email, $hash, $role, $active, $all]); $id = (int)$this->repo->db->lastInsertId(); }
            if (!$this->repo->one("SELECT u.id FROM users u JOIN roles r ON r.id=u.role_id WHERE r.name='Administrator' AND u.active=1 AND u.all_branches=1")) throw new HttpError(422, 'Minimal satu administrator global aktif diperlukan.');
            $this->repo->run('DELETE FROM user_branches WHERE user_id=?', [$id]);
            if (!$all) foreach ($branches as $branch) $this->repo->run('INSERT INTO user_branches(user_id,branch_id) VALUES (?,?)', [$id, $branch]);
            $this->audit->record((int)$this->access->user['id'], $before ? 'user_updated' : 'user_created', 'users', $id, ['before' => $before, 'after' => ['name' => $name, 'email' => $email, 'role_id' => $role, 'active' => $active, 'all_branches' => $all, 'branches' => $all ? [] : $branches], 'password_changed' => $hash !== null]);
            return $id;
        });
    }
}
