@echo off
set "PKG_CONFIG_PATH_CONDA_BACKUP=%PKG_CONFIG_PATH%"
if "%CONDA_BUILD%" == "1" (
  set "PKG_CONFIG_PATH=%PREFIX%\Library\lib\pkgconfig;%PKG_CONFIG_PATH%"
) else (
  set "PKG_CONFIG_PATH=%CONDA_PREFIX%\Library\lib\pkgconfig;%PKG_CONFIG_PATH%"
)
