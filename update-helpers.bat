@echo off
setlocal enabledelayedexpansion

set "SOURCE=108.0.2+up77.9.1-rancher.11"
set "BASEPATH=c:\Users\eyup.guner\Desktop\Github\charts\charts\rancher-monitoring-crd"

set "VERSIONS=108.0.1+up77.9.1-rancher.10 108.0.0+up77.9.1-rancher.6 107.2.2+up69.8.2-rancher.26 107.2.1+up69.8.2-rancher.23 107.2.0+up69.8.2-rancher.20 107.1.0+up69.8.2-rancher.15 107.0.0+up69.8.2-rancher.8"

for %%V in (%VERSIONS%) do (
    echo Updating %%V...
    copy /Y "%BASEPATH%\%SOURCE%\templates\_helpers.tpl" "%BASEPATH%\%%V\templates\_helpers.tpl" >nul
    copy /Y "%BASEPATH%\%SOURCE%\templates\NOTES.txt" "%BASEPATH%\%%V\templates\NOTES.txt" >nul
    echo   Done
)

echo.
echo All versions updated!
