<?php
declare(strict_types=1);
namespace Hls\Http;
final class Icons
{
    public static function svg(string $name): string
    {
        $paths = [
            'dashboard' => 'M3 10 12 3l9 7v11h-7v-7h-4v7H3z',
            'document' => 'M6 3h9l3 3v15H6zM14 3v5h4M9 12h6M9 16h6',
            'building' => 'M4 21V3h16v18M2 21h20M8 7h2m4 0h2M8 11h2m4 0h2M10 21v-6h4v6',
            'users' => 'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75',
            'shield' => 'M12 3 3 7v5c0 5 9 9 9 9s9-4 9-9V7zM8 12l3 3 5-6',
            'history' => 'M3 11a9 9 0 1 1 2 7M3 4v7h7M12 7v5l3 2',
            'menu' => 'M4 6h16M4 12h16M4 18h16', 'close' => 'M6 6l12 12M18 6 6 18',
            'chevron' => 'm9 5 7 7-7 7', 'user' => 'M20 21v-2a6 6 0 0 0-6-6h-4a6 6 0 0 0-6 6v2M12 9a4 4 0 1 0 0-8 4 4 0 0 0 0 8',
            'logout' => 'M9 21H3V3h6M9 12h12m-5-5 5 5-5 5',
            'truck' => 'M3 5h11v12H3zM14 9h4l3 4v4h-7M7 21a2 2 0 1 0 0-4 2 2 0 0 0 0 4M18 21a2 2 0 1 0 0-4 2 2 0 0 0 0 4',
            'package' => 'm3 7 9-4 9 4v10l-9 4-9-4zM3 7l9 5 9-5M12 12v9',
            'transfer' => 'M3 7h16m-4-4 4 4-4 4M21 17H5m4-4-4 4 4 4',
            'equipment' => 'M3 18h18M5 18V9h7v9M12 9l5-6 4 9M6 21h2m8 0h2',
            'alert' => 'm12 3 10 18H2zM12 9v5M12 17h.01',
            'search' => 'M21 21l-6-6M10 17a7 7 0 1 0 0-14 7 7 0 0 0 0 14',
            'calendar' => 'M3 5h18v16H3zM7 2v6M17 2v6M3 11h18',
            'check' => 'm5 12 4 4L19 6', 'wallet' => 'M3 5h17v16H3zM3 5V3h15M16 11h5v5h-5z',
            'chart' => 'M3 3v18h18M7 17v-5M12 17V8M17 17V5',
        ];
        return '<svg class="icon" aria-hidden="true" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="' . ($paths[$name] ?? $paths['document']) . '"/></svg>';
    }
}
