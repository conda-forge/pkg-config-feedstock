@echo ON

:: Makefile.vc predates Windows ARM64 and otherwise falls back to /machine:x86.
if "%target_platform%" == "win-arm64" (
    set "NMAKE_PLATFORM=ARM64"
) else (
    set "NMAKE_PLATFORM=x64"
)

if not exist release mkdir release
if not exist release\%NMAKE_PLATFORM% mkdir release\%NMAKE_PLATFORM%
if not exist release\%NMAKE_PLATFORM%\pkg-config mkdir release\%NMAKE_PLATFORM%\pkg-config
nmake /f Makefile.vc CFG=release PLAT=%NMAKE_PLATFORM% LDFLAGS_ARCH=/machine:%NMAKE_PLATFORM% GLIB_PREFIX=%LIBRARY_PREFIX%
if errorlevel 1 exit 1

copy release\%NMAKE_PLATFORM%\pkg-config.exe %LIBRARY_PREFIX%\bin\pkg-config.exe
if errorlevel 1 exit 1

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
FOR %%F IN (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d MKDIR %PREFIX%\etc\conda\%%F.d
    if errorlevel 1 exit 1
    copy %RECIPE_DIR%\scripts\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
    if errorlevel 1 exit 1
)
