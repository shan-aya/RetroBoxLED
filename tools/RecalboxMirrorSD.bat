@ECHO off
REM ANSI obligatoire
setlocal enabledelayedexpansion
chcp 1252 >nul
title Recalbox Mirror SD
color 0A

:main
cls
echo +==========================================+
echo ^|         Recalbox Mirror SD               ^|
echo +==========================================+
echo [1] Mirror + default/favorites
echo [2] Verifier SD
echo [3] Quitter
set /p choix=": "

if "%choix%"=="1" goto :mirror
if "%choix%"=="2" goto :show
goto :quit

:mirror
set /p drive="SD: "
set /p roms="Reseau: "
set "sys=%drive%:\systems"

echo Creation default/favorites...
mkdir "%sys%\default" 2>nul
mkdir "%sys%\favorites" 2>nul 

echo + default
echo + favorites

set c=2
for /f %%d in ('dir "%roms%" /ad /b 2^>nul') do (
    mkdir "%sys%\%%d" 2>nul
    echo + %%d
    set /a c+=1
)
echo TOTAL !c! dossiers
pause
goto :main

:show
set /p drive="SD: "
echo LISTAGE %drive%:\systems :
dir "%drive%:\systems" /ad /b /on | findstr /i "default favorites mame snes"
pause
goto :main

:quit
exit