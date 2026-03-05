# Exporte la base cinema_reservation vers un fichier SQL
# Usage: .\export_db.ps1  ou  .\export_db.ps1 -OutFile "C:\backup\cinema_2024.sql"

param(
    [string]$OutFile = "",
    [switch]$SchemaOnly,
    [switch]$DataOnly
)

$psql = "C:\Program Files\PostgreSQL\17\bin\psql.exe"
$pgDump = "C:\Program Files\PostgreSQL\17\bin\pg_dump.exe"
$dbName = "cinema_reservation"
$dbUser = "postgres"

if (-not (Test-Path $pgDump)) {
    Write-Error "pg_dump introuvable: $pgDump (ajuster le chemin si PostgreSQL est ailleurs)"
    exit 1
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmm"
if ($OutFile -eq "") {
    $OutFile = Join-Path $PSScriptRoot "export_cinema_reservation_$timestamp.sql"
}

$args = @("-U", $dbUser, "-d", $dbName, "-f", $OutFile)
if ($SchemaOnly) { $args += "--schema-only" }
if ($DataOnly)  { $args += "--data-only" }

Write-Host "Export vers: $OutFile"
& $pgDump @args
if ($LASTEXITCODE -ne 0) {
    Write-Error "Echec export (mot de passe postgres peut etre demande)"
    exit 1
}
Write-Host "OK. Fichier: $OutFile"
