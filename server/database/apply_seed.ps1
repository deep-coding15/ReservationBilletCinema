# Applique le schéma puis les seeds (films avec affiches, événements, etc.).
# Prérequis : PostgreSQL installé (ex. 17), base cinema_reservation créée.
# Usage : .\apply_seed.ps1   ou   .\apply_seed.ps1 -User postgres

param(
    [string]$User = "postgres",
    [string]$Db = "cinema_reservation"
)

# Trouver psql : PATH puis dossiers PostgreSQL 17/16/15 sous Program Files
$psqlExe = $null
if (Get-Command psql -ErrorAction SilentlyContinue) { $psqlExe = "psql" }
if (-not $psqlExe) {
    $pgVersions = @("17", "16", "15", "14")
    foreach ($v in $pgVersions) {
        $candidate = "${env:ProgramFiles}\PostgreSQL\$v\bin\psql.exe"
        if (Test-Path $candidate) { $psqlExe = $candidate; break }
    }
}
if (-not $psqlExe) { Write-Error "psql introuvable. Ajoutez le bin PostgreSQL au PATH ou installez PostgreSQL."; exit 1 }

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SchemaPath = Join-Path $ScriptDir "schema.sql"
$SeedPath = Join-Path $ScriptDir "seed_films.sql"

if (-not (Test-Path $SchemaPath)) { Write-Error "schema.sql introuvable : $SchemaPath"; exit 1 }
if (-not (Test-Path $SeedPath))   { Write-Error "seed_films.sql introuvable : $SeedPath"; exit 1 }

Write-Host "Application du schéma puis des seeds (films + images) sur $Db..."
& $psqlExe -U $User -d $Db -f $SchemaPath
if ($LASTEXITCODE -ne 0) { Write-Error "Echec schema"; exit 1 }
& $psqlExe -U $User -d $Db -f $SeedPath
if ($LASTEXITCODE -ne 0) { Write-Error "Echec seed"; exit 1 }
Write-Host "OK. Demarrez le serveur (dart run bin/main.dart) puis lancez l'app Flutter."
