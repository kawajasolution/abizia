# Persiapan shared hosting cPanel — fondasi

Dokumen persiapan saja; tidak mengakses hosting, mengunggah berkas, membuat database hosting atau mengklaim pengujian cPanel.

## Layout aman

Gunakan PHP 8.2+ dengan PDO MySQL, mbstring, session dan OpenSSL. Arahkan document root domain/subdomain ke `hls-v2/public`, bukan akar proyek. Letakkan app, config, database, bin, storage di luar document root. Seluruh source mengandalkan hubungan direktori ini; konfigurasi sensitif tidak perlu dipindah ke public.

Jika provider hanya membolehkan `public_html` tetap dan tidak dapat menunjuk ke direktori public aplikasi, perlu menyiapkan paket pemisahan public/private dengan path front controller yang disesuaikan serta diuji di staging. Jangan menyalin seluruh proyek ke public_html atau mengandalkan .htaccess sebagai satu-satunya pelindung konfigurasi.

Aktifkan HTTPS dan secure_cookie=true, base_path sesuai URL domain, writable storage khusus akun hosting, serta .htaccess/rewrite. Jangan mempercayai header HTTPS proxy dari klien tanpa konfigurasi proxy tepercaya provider. Secret DB hanya pada file konfigurasi privat di luar document root; contoh konfigurasi tidak mengandung password nyata.

## Database dan installer

Instalasi sekarang sengaja dibatasi database development/test HLS v2. Allowlist nama DB menolak nama lain, termasuk prefix akun cPanel. Saat ada otorisasi tahap deployment, siapkan konfigurasi/guard environment produksi tersendiri untuk nama DB cPanel, uji migration di DB staging kosong, dan berikan akun runtime privilege minimum. Jangan melemahkan allowlist development atau memakai database lama untuk mengatasi perbedaan prefix.

SQL fondasi dapat menjadi dasar paket instalasi baru, tanpa pengguna/cabang/password bawaan. Bootstrap saat ini CLI lokal; jangan menambah endpoint bootstrap web bila hosting tanpa SSH. Jalur bootstrap tanpa SSH perlu paket SQL hash privat sekali pakai yang dirancang dan diuji pada tahap deployment, bukan menaruh password atau installer publik. Jangan mengunggah bin/setup-dev.php sebagai alat instalasi hosting.

## Gerbang yang belum dijalankan

Verifikasi versi PHP/DB provider, TLS/cookie Secure, root public dan penolakan source, import/migration kosong, akun awal tanpa default, storage/session, error log privat, backup/restore dan smoke test izin/cabang pada staging. MySQL 8 dan hosting nyata belum diuji. Tahap 1 menyediakan pemisahan source/config yang mendukung persiapan ini; belum merupakan paket rilis cPanel siap pakai.
