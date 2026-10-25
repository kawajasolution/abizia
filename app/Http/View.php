<?php
declare(strict_types=1);
namespace Hls\Http;
use Hls\Services\Csrf;
final class View
{
    public function __construct(private array $config, private ?\Hls\Middleware\Access $access) {}
    public static function escape(mixed $value): string { return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }
    /** Formats monetary values for Indonesian display without redundant zero decimals. */
    public static function money(mixed $value): string
    {
        if ($value === null || $value === '') return 'Rp 0';
        if (!is_numeric($value)) return 'Rp 0';
        $n=(float)$value;
        $negative=$n<0; $n=abs($n);
        $formatted=number_format($n,2,',','.');
        $formatted=rtrim(rtrim($formatted,'0'),',');
        return ($negative?'-':'').'Rp '.($formatted===''?'0':$formatted);
    }
    public function url(string $path): string { return $this->config['base_path'] . $path; }
    public function csrf(): string { return '<input type="hidden" name="csrf" value="' . self::escape(Csrf::token()) . '">'; }
    public function component(string $component, array $data = []): string
    {
        if (!preg_match('/^[a-z-]+$/D', $component)) throw new \LogicException('Komponen tidak valid.');
        extract($data, EXTR_SKIP); $access = $this->access;
        ob_start(); require dirname(__DIR__) . '/Views/components/' . $component . '.php'; return ob_get_clean();
    }
    public function path(): string
    {
        $path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
        return substr($path, strlen($this->config['base_path'])) ?: '/';
    }
    public function render(string $template, array $data = []): void
    {
        extract($data, EXTR_SKIP); $access = $this->access;
        $navigation = new \Hls\Services\Navigation(require dirname(__DIR__) . '/navigation.php', require dirname(__DIR__) . '/routes.php');
        $groups = $access ? $navigation->groups($access) : [];
        $shortcuts = $access ? $navigation->shortcuts($access) : [];
        ob_start(); require dirname(__DIR__) . '/Views/' . $template . '.php'; $content = ob_get_clean();
        require dirname(__DIR__) . '/Views/layout.php';
    }
    public function redirect(string $path): never { header('Location: ' . $this->url($path), true, 303); exit; }
}
