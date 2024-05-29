@echo off
chcp 65001>nul
curl https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/unwrap.cmd -o temp_unwrap.cmd
set file=unwrap.cmd
powershell -command "(Get-Content "temp_unwrap.cmd") | Set-Content "unwrap.cmd"
del temp_unwrap.cmd
echo unwrap package manager has finished installing!
echo.
echo use unwrap -? for help commands or visit the github!
echo https://github.com/sjapanwala/unwrap-package-manager
