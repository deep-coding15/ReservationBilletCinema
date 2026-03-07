# Lance le backend et le frontend CinePass dans deux fenêtres separées.
# Double-cliquez sur ce script ou exécutez: powershell -ExecutionPolicy Bypass -File run_app.ps1

$projectRoot = $PSScriptRoot

# 1) Ouvrir une nouvelle fenêtre pour le backend
Start-Process powershell -ArgumentList @(
  "-NoExit",
  "-Command",
  "cd '$projectRoot\server'; Write-Host '=== BACKEND CinePass (port 8090) ===' -ForegroundColor Cyan; dart run bin/main.dart"
)

Start-Sleep -Seconds 2

# 2) Ouvrir une nouvelle fenêtre pour le frontend
Start-Process powershell -ArgumentList @(
  "-NoExit",
  "-Command",
  "cd '$projectRoot'; Write-Host '=== FRONTEND CinePass (Windows) ===' -ForegroundColor Green; flutter run -d windows"
)

Write-Host "Deux fenetres ont ete ouvertes:"
Write-Host "  - Backend (serveur) : attendez le message 'Listening on...' ou une erreur (ex: PostgreSQL)."
Write-Host "  - Frontend (app)    : attendez la fin de la compilation, la fenetre CinePass s'ouvrira."
Write-Host ""
Write-Host "Si le backend affiche une erreur de connexion PostgreSQL, demarrez PostgreSQL puis relancez."
