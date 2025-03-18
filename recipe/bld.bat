call %BUILD_PREFIX%\Library\bin\run_autotools_clang_conda_build.bat
if errorlevel 1 exit 1

for /f "delims=" %%i in ('cygpath -m %PREFIX%') do set "LIBRARY_PREFIX=%%i"
sed -i "s|%PREFIX%|%LIBRARY_PREFIX%|g" %LIBRARY_PREFIX%\lib\pkgconfig\chealpix.pc
if errorlevel 1 exit 1
