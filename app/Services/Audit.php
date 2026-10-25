<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Repositories\Repository;
final class Audit
{
    public function __construct(private Repository $repo) {}
    public function record(?int $actor, string $action, string $entity, ?int $id = null, array $detail = []): void
    {
        // Callers pass allowlisted metadata only, never request/session payloads.
        $this->repo->run('INSERT INTO audit_logs(actor_id,action,entity,entity_id,detail) VALUES (?,?,?,?,?)', [$actor, $action, $entity, $id, json_encode($detail, JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE)]);
    }
}
