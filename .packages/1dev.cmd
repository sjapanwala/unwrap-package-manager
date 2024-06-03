@echo off
chcp 65001>nul
setlocal enabledelayedexpansion
set overide=False
if "%1" == -ov set overide=True
echo Please Enter Package Link
set /p package_link=^> 
for /f "tokens=*" %%A in ("%package_link%") do (
    set "last_part=%%~nxA"
)
set filename=%last_part%
:choice
echo Is [91m%filename%[0m The Correct Package Name? This is What The Install Code Is
set /p choice=[y/n]
if %choice% == y goto correctname
if %choice% == Y goto correctname
if %choice% == N  goto setname
if %choice% == n  goto setname
goto choice

:setname
echo Please Enter A Package Name For Downloading of %filename%
set /p filename=^> 
:c2
echo Is [91m%filename%[0m The Correct Package Name? This is What The Install Code Is
set /p choice=[y/n]
if %choice% == Y goto correctname
if %choice% == y goto correctname
if %choice% == N  goto setname
if %choice% == n  goto setname
goto c2


:correctname
echo Please Enter Script Type ^(CMD,PS1...^)
set /p script_type=^> 
echo Please Enter Script Version ^(OMIT 0's^)
set /p version=^> 
echo.
echo Creating Code...
set "string=%filename%"

REM Get the length of the string
set "length=0"
for %%A in (!string!) do (
    set "str=%%A"
    for /l %%I in (1,1,100) do (
        set "char=!str:~%%I,1!"
        if not defined char (
            set "length=%%I"
            goto :next
        )
    )
)
:next
set /a spacelen= 14 - !length!
set "spaces="
for /l %%i in (1,1,%spacelen%) do (
    set "spaces=!spaces! "
)
if !length! gtr 14 (
    if overide == False (
        echo Name Too Long
        goto eof
    ) 
)
set code=[0m*[93m%script_type%WIN11V%version%.     [91m%filename%%spaces%[32m%package_link%[0m
echo | set /p=%code%|clip
if errorlevel == 0 (
    echo Code Has Been Copied To Clip Board.
) else (
    echo Code Was Unable To Be Copied To Clipboard
)
echo.
echo This is What It Should Look Like Formatted (Please Ensure Formatting Is Correct)
echo.
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/preview
echo %code%
:eof
