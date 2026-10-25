<?php
declare(strict_types=1);
namespace Hls\Repositories;
final class UserRepository extends Repository
{
    public function byEmail(string $email): ?array { return $this->one('SELECT * FROM users WHERE email=?', [$email]); }
    public function find(int $id): ?array { return $this->one('SELECT u.*,r.name AS role_name FROM users u JOIN roles r ON r.id=u.role_id WHERE u.id=?', [$id]); }
    public function listing(): array { return $this->all('SELECT u.id,u.name,u.email,u.active,u.all_branches,r.name AS role_name FROM users u JOIN roles r ON r.id=u.role_id ORDER BY u.id DESC'); }
    public function branches(int $id): array { return array_map('intval', array_column($this->all('SELECT branch_id FROM user_branches WHERE user_id=?', [$id]), 'branch_id')); }
}
