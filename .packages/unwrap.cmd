@echo off
chcp 65001>nul
setlocal enabledelayedexpansion

if "%1" == "-repairself" (
    goto repairself
)

set cmdres=[0m[[91munwrap[0m]:
:: get path
for /f "tokens=*" %%a in ('powershell -Command "(Get-Content 'C:\users\%username%\.unwrap\.config\config.json' | ConvertFrom-Json)."download_location" "') do (
    set "download_location=%%a"
)
REM Sample string containing an object
set "convert=%download_location%"

REM Replace "fox" with "cat"
set "converted_location=%convert:auser=!username!%"
:: init commands
:main
if "%1" == "-search" (
    if not "%2" == "" (
        set package_name=%2
        goto def_search_packages
        echo %cmdres% Arguement Error: Package Name Not Defined
        goto eof
    ) else (
        echo %cmdres% Arguement Error: Package Name Not Defined
        goto eof
    )
)
if "%1" == "-install" (
    set show_raw=False
    if "%2" == "" (
        echo %cmdres% Arguement Error: Package Name Not Defined
        goto eof
    ) else (
        if "%3" == "-raw" (
            set show_raw=True
        )
    set package_name=%2
    goto def_install_packages
    )
)

if "%1" == "-?" (
    goto def_help
)

if "%1" == "-repair" (
    if "%2" == "" (
        echo %cmdres% Path Error: Please Provide A File inside "%converted_location%".
        goto eof
    ) else (
        if not exist "%converted_location%\%2" (
            echo %cmdres% Path Error: Please Prove A Path That Exists Inside "%converted_location%"
            goto eof
        ) else (
            set repair_file_path=%converted_location%\%2
            set repair_file=%2
            goto def_repair_download
        )
    )
)

if "%1" == "-help" (
    goto def_help
)

if "%1" == "-init" (
    goto def_init
)

if "%1" == "-upt" (
    goto def_update
)
:defined_error
echo.
echo %cmdres% Arguement Error: No Optin Given or Invalid Option Given
echo Try "-?" for help and commands.
goto eof

:def_init
echo [0m[[92mINIT[0m]:Starting Initialization...

:: checking if the root directory exists
echo [0m[[93mSCANNING[0m]: Root Dir
if not exist "C:\users\%username%\.unwrap" (
    echo [0m[[91mNOTFOUND[0m]
    echo [0m[[94mCONSTRUCTING[0m]: Root Dir
    mkdir "C:\users\%username%\.unwrap"
) else (
    echo [0m[[92mGOOD[0m]: Root Dir
)

:: checking if the packages directory exists
echo [0m[[93mSCANNING[0m]: Package Dir
if not exist "C:\users\%username%\.unwrap\.packages" (
    echo [0m[[91mNOTFOUND[0m]
    echo [0m[[94mCONSTRUCTING[0m]: Package Links
    mkdir "C:\users\%username%\.unwrap\.packages"
) else (
        echo [0m[[92mGOOD[0m]: Packages Dir
)

:: making the packages
echo [0m[[93mSCANNING[0m]: Package Links
if not exist "C:\users\%username%\.unwrap\.packages\package_links.json" (
    echo [0m[[91mNOTFOUND[0m]
    echo [0m[[94mCONSTRUCTING[0m]: Package Links
    curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/packages.json>"C:\users\%username%\.unwrap\.packages\package_links.json"
) else (
        echo [0m[[92mGOOD[0m]: Packages
)

:: making the config dir
echo [0m[[93mSCANNING[0m]: Config Dir
if not exist "C:\users\%username%\.unwrap\.config" (
    echo [0m[[91mNOTFOUND[0m]
    echo [0m[[94mCONSTRUCTING[0m]: Config Dir
    mkdir "C:\users\%username%\.unwrap\.config"
) else (
        echo [0m[[92mGOOD[0m]: Config Dir
)

::making the config file
echo [0m[[93mSCANNING[0m]: Config File
if not exist "C:\users\%username%\.unwrap\.config\config.json" (
    echo [0m[[91mNOTFOUND[0m]
    echo [0m[[94mCONSTRUCTING[0m]: Config File
    echo {"download_location": "C:\\Users\\auser\\Downloads"}>"C:\users\%username%\.unwrap\.config\config.json"
) else (
        echo [0m[[92mGOOD[0m]: Config File
)

echo.
echo Finished!
goto eof


:def_install_packages
::if not exist C:\users\%username%\.package_links (
::    echo %cmdres% Initialization Error: Package Links Not Initialized.
::    echo Try "-init" to complete Initialization Processes.
::)
for /f "tokens=*" %%a in ('powershell -Command "(Get-Content 'C:\users\%username%\.unwrap\.packages\package_links.json' | ConvertFrom-Json)."!package_name!" "') do (
    set "package_link=%%a"
)

if not defined package_link (
    echo %cmdres% No Such Package Found
    goto eof
)
echo Downloading...
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━[0m━━━━━━━━━━━━━━━━━━━━ - Collected Packets, Applying Packets and Installing
curl -s %package_link%>%converted_location%\%package_name%.cmd
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m - Applied Packets and Installing
echo Successfully Downloaded...
goto eof

:def_help
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/help
goto eof

:def_update
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━[0m━━━━━━━━━━━━━━━━━━━━ - Collecting Updated Packages
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/packages.json>"C:\users\%username%\.unwrap\.packages\package_links.json"
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m - Applying Collected Packages
echo.
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/updates
goto eof    


:def_repair_download
echo Diagnosing "%repair_file_path%"
echo Attepting Repairs.
echo.
copy %repair_file_path%>nul
::(Get-Content "%repair_file_path%") | Set-Content "%repair_file%"
powershell -command "(Get-Content "%repair_file_path%") | Set-Content "%repair_file%"
timeout 2 >nul
del %repair_file_path%>nul
move %repair_file% "%converted_location%">nul
if not %errorlevel% == 0 (
    echo [0mFile Was Unable To be Repaired
    goto eof
) else (
    echo Files Were Successfully Repaired!
)
goto eof

:def_search_packages
for /f "tokens=*" %%a in ('powershell -Command "(Get-Content 'C:\users\%username%\.unwrap\.packages\package_links.json' | ConvertFrom-Json)."!package_name!" "') do (
    set "package_ver=%%a"
)
:: find author

set "url=%package_ver%"

:: Initialize variables
set "count=0"
set "segment="

:: Loop through each character in the URL
:loop
if "%url:~0,1%"=="" goto :done
set "char=%url:~0,1%"
set "url=%url:~1%"

if "%char%"=="/" (
    set /a count+=1
)

if %count%==3 (
    set "segment=!segment!!char!"
) else if %count%==4 (
    goto :done
)

goto :loop

:done
:: Remove leading and trailing slashes from the segment
set "author_name=%segment:~1%"

if defined package_ver (
    goto show_package_info
) else (
    goto nofound
)

:show_package_info
echo Package Actuality: [92mTrue[0m
echo Package Author:    [90m%author_name%[0m
goto eof

:nofound
echo nonefound
goto eof

:repairself
copy "unwrap.bat" "unwrapmain.cmd"
powershell -command "(Get-Content "unwrap.bat") | Set-Content "unwrapmain.cmd"
rename "unwrapmain.cmd" "unwrap.cmd"
del unwrap.bat

:eof
