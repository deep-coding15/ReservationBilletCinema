# Promouvoir un utilisateur en administrateur (exécute promote_admin.sql).
# Prérequis : PostgreSQL installé, base cinema_reservation existante.
# Usage : .\promote_admin.ps1   ou   .\promote_admin.ps1 -User postgres
# Modifiez l'email dans promote_admin.sql (v_email) avant d'exécuter.

param(
    [string]$User = "postgres",
    [string]$Db = "cinema_reservation"
)

$psqlExe = $null
if (Get-Command psql -ErrorAction SilentlyContinue) { $psqlExe = "psql" }
if (-not $psqlExe) {
    $pgVersions = @("17", "16", "15", "14")
    foreach ($v in $pgVersions) {
        $candidate = "${env:ProgramFiles}\PostgreSQL\$v\bin\psql.exe"
        if (Test-Path $candidate) { $psqlExe = $candidate; break }
    }
}
if (-not $psqlExe) {
    Write-Host "psql introuvable. Soit :"
    Write-Host "  1) Installez PostgreSQL (https://www.postgresql.org/download/windows/)"
    Write-Host "  2) Soit ajoutez le dossier bin de PostgreSQL au PATH (ex. C:\Program Files\PostgreSQL\17\bin)"
    exit 1
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SqlPath = Join-Path $ScriptDir "promote_admin.sql"
if (-not (Test-Path $SqlPath)) { Write-Error "promote_admin.sql introuvable : $SqlPath"; exit 1 }

Write-Host "Execution de promote_admin.sql sur $Db (utilisateur: $User)..."
& $psqlExe -U $User -d $Db -f $SqlPath
if ($LASTEXITCODE -ne 0) { Write-Error "Echec."; exit 1 }
Write-Host "OK. Reconnectez-vous dans l'app pour voir l'icone Espace admin."
