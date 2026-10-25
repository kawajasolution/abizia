<?php
declare(strict_types=1);
namespace Hls\Http;
final class Router
{
    public function __construct(private array $routes) {}
    public function resolve(string $method, string $path): array
    {
        if (!isset($this->routes[$path])) throw new HttpError(404, 'Halaman tidak ditemukan.');
        if (!isset($this->routes[$path][$method])) throw new HttpError(405, 'Metode tidak diizinkan.');
        return $this->routes[$path][$method];
    }
}
