@echo off
chcp 65001>nul
setlocal enabledelayedexpansion

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

if "%1" == "-pkglist" (
    goto def_list_packages
)

if "%1" == "-more" (
    goto def_show_more
)

if not "%1" == "" (
    goto defined_error
) else (
    echo %cmdres% Arguement Error: No Command Provided
    echo Try "-?" for help and commands.
    goto eof
)

:defined_error
echo %cmdres% Arguement Error: "%1" is Too Ambiguous
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

::making the temp file
echo [0m[[93mSCANNING[0m]: Temp Dir
if not exist "C:\users\%username%\.unwrap\.temp" (
    echo [0m[[91mNOTFOUND[0m]
    echo [0m[[94mCONSTRUCTING[0m]: Temp Dir
    mkdir "C:\users\%username%\.unwrap\.temp"
) else (
        echo [0m[[92mGOOD[0m]: Temp Dir
)

::temp mem
::making the temp file
echo [0m[[93mSCANNING[0m]: Temp Mem
if not exist "C:\users\%username%\.unwrap\.temp\memory" (
    echo [0m[[91mNOTFOUND[0m]
    echo [0m[[94mCONSTRUCTING[0m]: Temp memory
    mkdir "C:\users\%username%\.unwrap\.temp\memory"
) else (
        echo [0m[[92mGOOD[0m]: Temp memory
)

echo.
echo Finished!
goto eof


:def_install_packages
for /f "tokens=*" %%a in ('powershell -Command "(Get-Content 'C:\users\%username%\.unwrap\.packages\package_links.json' | ConvertFrom-Json)."!package_name!" "') do (
    set "package_link=%%a"
)

if not defined package_link (
    echo %cmdres% No Such Package Found
    goto eof
)

echo Reading Package Links...
if exist "C:\users\%username%\.unwrap\.temp\memory\%package_name%.mem" (
    echo [31mSome Packages Already Exist for %package_name%[0m
)
echo Verifying Package Life Span...
echo.
curl -s %package_link%>"C:\users\%username%\.unwrap\.temp\%package_name%.unw"
set FILE_PATH="C:\users\%username%\.unwrap\.temp\%package_name%.unw"
for %%F in (%FILE_PATH%) do set FILE_SIZE=%%~zF
echo The Following Package Will Be Installed,
echo    %package_name%:    !FILE_SIZE![32mKB[0m
:choose_cont
set choice=""
set /p choice=Do You Want To Continue? [y/n]: 
if %choice% == y goto installfile
if %choice% == Y goto installfile
if %choice% == N goto wipe_file
if %choice% == n goto wipe_file
goto choose_cont

:wipe_file
echo Install Aborted, Destorying Temp Package
del "C:\users\%username%\.unwrap\.temp\%package_name%.unw"
if errorlevel == 0 (
    echo %cmdres% Temp Packages Destoryed
    goto eof
) else (
    echo %cmdres%: Error in Destorying Temp Packages: Errorlevel %errorlevel%
    goto eof
)
goto eof

:installfile
echo Installing to Path "%converted_location%"
echo.
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━[0m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
powershell -command "(Get-Content "C:\users\%username%\.unwrap\.temp\%package_name%.unw") | Set-Content "C:\users\%username%\.unwrap\.temp\%package_name%.cmd"
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━[0m━━━━━━━━━━━━━━━━━━━━━
move "C:\users\%username%\.unwrap\.temp\%package_name%.cmd" "%converted_location%">nul
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m━━━━━━
echo memory>"C:\users\%username%\.unwrap\.temp\memory\%package_name%.mem"
timeout 3 >nul 
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m
echo.
echo Finalizing Processes...
PING -n 1 8.8.8.8 | FIND "TTL=">nul
echo [Checking Location]
if not exist %converted_location%\%package_name%.cmd (
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo [Location not correct, please re-install]
) else (
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo [Location Verified]
)
echo [Unpacking Final Processes]
PING -n 1 8.8.8.8 | FIND "TTL=">nul
echo [Processes Finished, Install Complete!]
PING -n 1 8.8.8.8 | FIND "TTL=">nul
goto eof

:def_help
::curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/help
echo Usage: unwrap ^<COMMAND^> [^<ARGS...^>]
echo.
echo COMMAND,  ARGS,
echo -?/-help                 shows the help menu, (this menu)
echo -install [PKGNAME]       install packages from the unwrap script database
echo -init                    initialize the package manager, this is required on first boot
echo -upt                     update the packages to install
echo -repair  [FILENAME]      use this command to repair the encoding (if a file doesnt work)
echo -search  [PKGNAME]       search for packages, if none found, try "unwrap -upt"
echo -pkgpush [FILENAME]      upload a package to a custom database, which can be sent to main packages
echo                            (requires unwrapy.py package to be installed)
echo -pkglist                 lists all available packages, ~5mins from updates
echo -more                    shows more information
goto eof

:def_update
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/notify-update
:choose_cont2
set choice=""
set /p choice=Do You Want To Continue? [y/n]: 
if %choice% == y goto update_file
if %choice% == Y goto update_file
if %choice% == N goto eof
if %choice% == n goto eof
goto choose_cont2
:update_file
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━[0m━━━━━━━━━━━━━━━━━━━━ - Collecting Updated Packages
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/packages.json>"C:\users\%username%\.unwrap\.packages\package_links.json"
PING -n 1 8.8.8.8 | FIND "TTL=">nul && echo [31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m - Applying Collected Packages
echo.
::curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/updates
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

:def_list_packages
echo.
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/list-packages
goto eof

:def_show_more
goto eof
echo ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀
echo ⠀⠀⠀⠀⢀⣠⣶⣾⣿⣿⣿⣦⡀⠀⠀⢀⣴⣿⣿⣿⣷⣶⣄⡀⠀⠀
echo ⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⠿⠛⠉⢠⡄⠉⠛⠿⣿⣿⣿⣿⣿⣿⣷
echo ⠀⠈⠻⣿⣿⣿⡿⠟⠋⠁⠀⠀⠀⢸⡇⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⠟⠁⠀
echo ⠀⠀⠀⠈⠋⠁⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠈⠙⠁⠀⠀⠀⠀
echo ⠀⠀⠀⣰⣷⣦⣄⡀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⢀⣠⣴⣾⣆⠀⠀⠀⠀ 
echo ⠀⢠⣾⣿⣿⣿⣿⣿⣷⣦⣄⠀⠀⢸⡇⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣷⡄  
echo ⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠖⠀⠀⠲⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀ 
echo ⠀⠀⠀⠀⠉⠛⠿⣿⣿⣿⠟⢁⣴⡇⢸⣦⡈⠻⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀
echo ⠀⠀⠀⠀⢸⣷⣦⣄⡉⢁⣴⣿⣿⡇⢸⣿⣿⣦⡈⢉⣠⣴⣾⡇⠀
echo ⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀
echo ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⡇⢸⣿⡿⠟⠋⠁⠀⠀⠀⠀⠀
echo ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
echo.
echo welcome to unwrap package manager, a package manager for windows scripts, pyscripts, vimscripts, etc...
goto eof
:eof
