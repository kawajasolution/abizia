<?php
declare(strict_types=1);
namespace Hls\Http;
final class Pagination
{
    public static function slice(array $rows, array $query): array
    {
        $page = Input::text($query, 'page', 6, false) ?: '1';
        if (!ctype_digit($page) || (int)$page < 1) throw new HttpError(422, 'Nomor halaman tidak valid.');
        $total = count($rows); $perPage = 10; $pages = max(1, (int)ceil($total / $perPage)); $page = min((int)$page, $pages);
        return ['rows' => array_slice($rows, ($page - 1) * $perPage, $perPage), 'pagination' => compact('total', 'perPage', 'pages', 'page')];
    }
}
