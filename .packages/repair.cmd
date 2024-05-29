@echo off
setlocal enabledelayedexpansion
if not "%1" == "" (
    if exist "%~1" (
        set filename=%~1
        goto skipinput
    ) else (
        echo no such file exists
        goto eof
    )
) else (
    goto setinput
)
:setinput
set /p filename=filename ^> 
if not exist %filename% (
    echo no such file exist
    goto eof
)
:skipinput
set tempfile=temp_!filename!
powershell -command "(Get-Content "!filename!") | Set-Content "!tempfile!"
del !filename!
rename !tempfile! !filename!
if errorlevel == 0 (
    echo Successfully Repaired !filename!
) else (
    echo Error Occured
)
:eof
