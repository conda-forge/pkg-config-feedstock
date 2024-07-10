@echo ON

mkdir release\
mkdir release\x64
mkdir release\x64\pkg-config
nmake /f Makefile.vc CFG=release GLIB_PREFIX=%LIBRARY_PREFIX%
if errorlevel 1 exit 1

copy release\x64\pkg-config.exe %LIBRARY_PREFIX%\bin\pkg-config.exe
if errorlevel 1 exit 1

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
FOR %%F IN (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d MKDIR %PREFIX%\etc\conda\%%F.d
    if errorlevel 1 exit 1
    copy %RECIPE_DIR%\scripts\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
    if errorlevel 1 exit 1
)
