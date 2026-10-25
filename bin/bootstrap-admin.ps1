param([Parameter(Mandatory=$true)][string]$Name,[Parameter(Mandatory=$true)][string]$Email)
$secret = Read-Host 'Password administrator (12-72 byte)' -AsSecureString
$confirm = Read-Host 'Ulangi password' -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
$ptrConfirm = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirm)
$previousOutputEncoding = $OutputEncoding
try {
    $OutputEncoding = [Text.UTF8Encoding]::new($false)
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    if ($plain -cne [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptrConfirm)) { throw 'Konfirmasi password tidak cocok.' }
    $plain | & php (Join-Path $PSScriptRoot 'bootstrap-admin.php') $Name $Email
    if ($LASTEXITCODE -ne 0) { throw 'Bootstrap gagal.' }
} finally {
    $OutputEncoding = $previousOutputEncoding
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptrConfirm)
    $plain = $null
    $secret.Dispose()
    $confirm.Dispose()
}
