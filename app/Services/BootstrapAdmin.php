<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Database;
use Hls\Http\Input;
use Hls\Repositories\Repository;
final class BootstrapAdmin
{
    public static function create(Repository $repo, string $name, string $email, string $password): int
    {
        $name = Input::text(['name' => $name], 'name', 100); $email = strtolower(trim($email));
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($email) > 190) throw new \RuntimeException('Email tidak valid.');
        $hash = Input::password($password);
        return Database::transaction($repo->db, function () use ($repo, $name, $email, $hash): int {
            // Lock a pre-existing row so two empty-user bootstraps serialize.
            $role = $repo->one("SELECT id FROM roles WHERE name='Administrator' FOR UPDATE");
            if (!$role || $repo->one('SELECT id FROM users LIMIT 1 FOR UPDATE')) throw new \RuntimeException('Bootstrap hanya diizinkan ketika users kosong.');
            $repo->run('INSERT INTO users(name,email,password_hash,role_id,all_branches) VALUES (?,?,?,?,1)', [$name, $email, $hash, $role['id']]);
            $id = (int)$repo->db->lastInsertId();
            (new Audit($repo))->record($id, 'administrator_bootstrapped', 'users', $id);
            return $id;
        });
    }
}
