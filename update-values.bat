@echo off
setlocal enabledelayedexpansion

set "BASEPATH=c:\Users\eyup.guner\Desktop\Github\charts\charts\rancher-monitoring-crd"

REM Update 108.x series (use source values.yaml)
echo Updating 108.0.1...
copy /Y "%BASEPATH%\108.0.2+up77.9.1-rancher.11\values.yaml" "%BASEPATH%\108.0.1+up77.9.1-rancher.10\values.yaml.tmp" >nul
powershell -Command "(Get-Content '%BASEPATH%\108.0.1+up77.9.1-rancher.10\values.yaml.tmp') -replace 'tag: \"108\.0\.2\"', 'tag: \"108.0.1\"' | Set-Content '%BASEPATH%\108.0.1+up77.9.1-rancher.10\values.yaml'"
del "%BASEPATH%\108.0.1+up77.9.1-rancher.10\values.yaml.tmp"

echo Updating 108.0.0...
copy /Y "%BASEPATH%\108.0.2+up77.9.1-rancher.11\values.yaml" "%BASEPATH%\108.0.0+up77.9.1-rancher.6\values.yaml.tmp" >nul
powershell -Command "(Get-Content '%BASEPATH%\108.0.0+up77.9.1-rancher.6\values.yaml.tmp') -replace 'tag: \"108\.0\.2\"', 'tag: \"108.0.0\"' | Set-Content '%BASEPATH%\108.0.0+up77.9.1-rancher.6\values.yaml'"
del "%BASEPATH%\108.0.0+up77.9.1-rancher.6\values.yaml.tmp"

REM Update 107.x series (use template values.yaml)
echo Updating 107.2.2...
copy /Y "c:\Users\eyup.guner\Desktop\Github\charts\values-107.yaml" "%BASEPATH%\107.2.2+up69.8.2-rancher.26\values.yaml.tmp" >nul
powershell -Command "(Get-Content '%BASEPATH%\107.2.2+up69.8.2-rancher.26\values.yaml.tmp') -replace 'VERSION_TAG', '107.2.2' | Set-Content '%BASEPATH%\107.2.2+up69.8.2-rancher.26\values.yaml'"
del "%BASEPATH%\107.2.2+up69.8.2-rancher.26\values.yaml.tmp"

echo Updating 107.2.1...
copy /Y "c:\Users\eyup.guner\Desktop\Github\charts\values-107.yaml" "%BASEPATH%\107.2.1+up69.8.2-rancher.23\values.yaml.tmp" >nul
powershell -Command "(Get-Content '%BASEPATH%\107.2.1+up69.8.2-rancher.23\values.yaml.tmp') -replace 'VERSION_TAG', '107.2.1' | Set-Content '%BASEPATH%\107.2.1+up69.8.2-rancher.23\values.yaml'"
del "%BASEPATH%\107.2.1+up69.8.2-rancher.23\values.yaml.tmp"

echo Updating 107.2.0...
copy /Y "c:\Users\eyup.guner\Desktop\Github\charts\values-107.yaml" "%BASEPATH%\107.2.0+up69.8.2-rancher.20\values.yaml.tmp" >nul
powershell -Command "(Get-Content '%BASEPATH%\107.2.0+up69.8.2-rancher.20\values.yaml.tmp') -replace 'VERSION_TAG', '107.2.0' | Set-Content '%BASEPATH%\107.2.0+up69.8.2-rancher.20\values.yaml'"
del "%BASEPATH%\107.2.0+up69.8.2-rancher.20\values.yaml.tmp"

echo Updating 107.1.0...
copy /Y "c:\Users\eyup.guner\Desktop\Github\charts\values-107.yaml" "%BASEPATH%\107.1.0+up69.8.2-rancher.15\values.yaml.tmp" >nul
powershell -Command "(Get-Content '%BASEPATH%\107.1.0+up69.8.2-rancher.15\values.yaml.tmp') -replace 'VERSION_TAG', '107.1.0' | Set-Content '%BASEPATH%\107.1.0+up69.8.2-rancher.15\values.yaml'"
del "%BASEPATH%\107.1.0+up69.8.2-rancher.15\values.yaml.tmp"

echo Updating 107.0.0...
copy /Y "c:\Users\eyup.guner\Desktop\Github\charts\values-107.yaml" "%BASEPATH%\107.0.0+up69.8.2-rancher.8\values.yaml.tmp" >nul
powershell -Command "(Get-Content '%BASEPATH%\107.0.0+up69.8.2-rancher.8\values.yaml.tmp') -replace 'VERSION_TAG', '107.0.0' | Set-Content '%BASEPATH%\107.0.0+up69.8.2-rancher.8\values.yaml'"
del "%BASEPATH%\107.0.0+up69.8.2-rancher.8\values.yaml.tmp"

echo.
echo All values.yaml files updated!
