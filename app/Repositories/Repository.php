<?php
declare(strict_types=1);
namespace Hls\Repositories;
class Repository
{
    public function __construct(public readonly \PDO $db) {}
    public function run(string $sql, array $args = []): \PDOStatement { $stmt = $this->db->prepare($sql); $stmt->execute($args); return $stmt; }
    public function one(string $sql, array $args = []): ?array { return $this->run($sql, $args)->fetch() ?: null; }
    public function all(string $sql, array $args = []): array { return $this->run($sql, $args)->fetchAll(); }
}
