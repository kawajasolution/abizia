<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Database;
use Hls\Http\HttpError;
use Hls\Repositories\UserRepository;
final class Auth
{
    public function __construct(private UserRepository $users, private Audit $audit, private array $config) {}
    private function stamp(array $user): string { return hash('sha256', $user['password_hash'] . ':' . $user['auth_version']); }
    public function current(?int $now = null): ?array
    {
        if (!isset($_SESSION['user_id'])) return null;
        $now ??= time();
        $user = $this->users->find((int)$_SESSION['user_id']);
        if (!$user || !$user['active'] || !hash_equals($this->stamp($user), (string)($_SESSION['stamp'] ?? '')) || $now - (int)($_SESSION['last_activity'] ?? 0) >= $this->config['idle_timeout']) {
            $this->audit->record($user ? (int)$user['id'] : null, 'session_invalidated', 'auth');
            $_SESSION = []; session_regenerate_id(true); return null;
        }
        $_SESSION['last_activity'] = $now;
        return $user;
    }
    public function login(string $email, string $password, string $ip): void
    {
        $email = mb_strtolower(trim($email));
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($email) > 190 || strlen($password) > 72) throw new HttpError(422, 'Email atau password tidak valid.');
        $emailKey = hash('sha256', $email); $ipKey = hash('sha256', $ip);
        $locks = ['hlsv2:' . substr(hash('sha256', $this->config['database'] . $emailKey), 0, 55), 'hlsv2:' . substr(hash('sha256', $this->config['database'] . $ipKey), 0, 55)];
        sort($locks); $held = [];
        try {
            foreach ($locks as $lock) { if ((int)$this->users->one('SELECT GET_LOCK(?,5) AS acquired', [$lock])['acquired'] !== 1) throw new HttpError(503, 'Silakan coba kembali.'); $held[] = $lock; }
            $count = $this->users->one('SELECT COUNT(*) AS total FROM login_attempts WHERE (email_key=? OR ip_key=?) AND attempted_at>DATE_SUB(NOW(),INTERVAL 15 MINUTE)', [$emailKey, $ipKey]);
            if ((int)$count['total'] >= 5) { $this->audit->record(null, 'login_limited', 'auth'); throw new HttpError(429, 'Terlalu banyak percobaan. Coba kembali setelah 15 menit.'); }
            $user = $this->users->byEmail($email);
            $hash = $user['password_hash'] ?? '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.';
            $valid = password_verify($password, $hash) && $user && $user['active'];
            if (!$valid) {
                Database::transaction($this->users->db, function () use ($emailKey, $ipKey): void { $this->users->run('INSERT INTO login_attempts(email_key,ip_key) VALUES (?,?)', [$emailKey, $ipKey]); $this->audit->record(null, 'login_failed', 'auth'); });
                throw new HttpError(401, 'Email atau password tidak sesuai.');
            }
            $this->audit->record((int)$user['id'], 'login_succeeded', 'auth');
            session_regenerate_id(true);
            $_SESSION = ['user_id' => (int)$user['id'], 'stamp' => $this->stamp($user), 'last_activity' => time()];
        } finally { foreach (array_reverse($held) as $lock) $this->users->run('SELECT RELEASE_LOCK(?)', [$lock]); }
    }
    public function logout(array $user): void
    {
        $this->audit->record((int)$user['id'], 'logout', 'auth');
        $_SESSION = [];
        $cookie = session_get_cookie_params();
        setcookie(session_name(), '', ['expires' => time() - 3600, 'path' => $cookie['path'], 'secure' => $cookie['secure'], 'httponly' => true, 'samesite' => 'Lax']);
        session_destroy();
    }
}
