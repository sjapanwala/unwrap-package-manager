@echo off
chcp 65001>nul
echo Welcome To Unwrap Builder
:choice
echo.
echo Please Choose An Installation
set choice=.
set /p choice=[s] Fast Install, [c] Custom Install, [p] Part-Part Install Using Batcher: 
if %choice%==s goto fast_install
if %choice%==c goto custom_install
if %choice%==p goto part_install
goto choice

:fast_install
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/unwrap.cmd -o temp_unwrap.cmd
set file=unwrap.cmd
powershell -command "(Get-Content "temp_unwrap.cmd") | Set-Content "unwrap.cmd"
del temp_unwrap.cmd
echo.
goto eof

:custom_install
echo.
echo Requires Admin Permissions
goto fast_install


:part_install
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/unwrap.cmd -o unwrap.cmd
echo Main File Installed... Installing Batcher...
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/repair.cmd -o batcher.cmd
echo Batcher Installed... Running Batcher...
echo.
echo unwrap package manager has finished installing!
echo.
echo use unwrap -? for help commands or visit the github!
echo https://github.com/sjapanwala/unwrap-package-manager
batcher.cmd unwrap.cmd 

:eof
echo unwrap package manager has finished installing!
echo.
echo use unwrap -? for help commands or visit the github!
echo https://github.com/sjapanwala/unwrap-package-manager
