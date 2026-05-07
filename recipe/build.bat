cd "%SRC_DIR%\src\C\autotools"
del /f /q chealpix.c chealpix.h test_chealpix.c
copy /y "..\subs\chealpix.c" .
copy /y "..\subs\chealpix.h" .
copy /y "..\subs\test_chealpix.c" .
if %ERRORLEVEL% neq 0 exit 1

cd "%SRC_DIR%"
call %BUILD_PREFIX%\Library\bin\run_autotools_clang_conda_build.bat
if %ERRORLEVEL% neq 0 exit 1

for /f "delims=" %%i in ('cygpath -m %PREFIX%') do set "LIBRARY_PREFIX=%%i"
sed -i "s|%PREFIX%|%LIBRARY_PREFIX%|g" %LIBRARY_PREFIX%\lib\pkgconfig\chealpix.pc
if %ERRORLEVEL% neq 0 exit 1
