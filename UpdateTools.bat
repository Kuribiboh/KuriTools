@echo off
setlocal

REM Get the batch file’s directory
set "basedir=%~dp0"

REM Path to the PowerShell scripts
set "ps1folder=%basedir%Downloaders"

REM Run each script, passing the base dir to it
for %%F in ("%ps1folder%\*.ps1") do (
    echo Running %%~nxF...
    powershell -ExecutionPolicy Bypass -NoProfile -File "%%F" -BasePath %basedir%

)

REM Clean up
rmdir /s /q %~dp0Tools\Temp

echo All scripts completed.
pause
