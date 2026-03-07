@echo off
chcp 65001 >nul
echo ============================================
echo   CinePass - BACKEND (serveur)
echo ============================================
echo.
cd /d "%~dp0server"
echo Repertoire: %CD%
echo.
echo Demarrage du serveur (port 8090)...
echo Si rien ne s'affiche apres "demarrage...", le serveur peut attendre la base PostgreSQL.
echo.
dart run bin/main.dart
echo.
echo Le serveur s'est arrete. Appuyez sur une touche pour fermer.
pause >nul
