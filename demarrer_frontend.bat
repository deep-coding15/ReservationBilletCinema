@echo off
chcp 65001 >nul
echo ============================================
echo   CinePass - FRONTEND (application)
echo ============================================
echo.
cd /d "%~dp0"
echo Repertoire: %CD%
echo.
echo Compilation et lancement de l'app Windows...
echo La fenetre CinePass s'ouvrira quand la compilation est terminee (1-2 min la 1ere fois).
echo.
flutter run -d windows
echo.
echo L'app s'est fermee. Appuyez sur une touche pour fermer ce terminal.
pause >nul
