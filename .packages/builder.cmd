@echo off
chcp 65001>nul
curl https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/unwrap.cmd -o temp_unwrap.cmd
set file=unwrap.cmd
powershell -command "(Get-Content "temp_unwrap.cmd") | Set-Content "unwrap.cmd"
echo done
