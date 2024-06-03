@echo off
chcp 65001>nul
setlocal enabledelayedexpansion
title Currently Unwrapping

set cmdres=[0m[[91munwrap[0m]:
:: get path
for /f "tokens=*" %%a in ('powershell -Command "(Get-Content 'C:\users\%username%\.unwrap\.config\config.json' | ConvertFrom-Json)."download_location" "') do (
    set "download_location=%%a"
)
REM Sample string containing an object
set "convert=%download_location%"

set "converted_location=%convert:auser=!username!%"
:: init commands
:main
if "%1" == "-search" (
    if not "%2" == "" (
        set package_name=%2
        goto def_search_packages
    ) else (
        echo %cmdres% Arguement Error; Package Name Not Defined
        goto eof
    )
)
if "%1" == "-install" (
    set show_raw=False
    if "%2" == "" (
        echo %cmdres% Arguement Error; Package Name Not Defined
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
        echo %cmdres% Path Error; Please Provide A File inside "%converted_location%".
        goto eof
    ) else (
        if not exist "%converted_location%\%2" (
            echo %cmdres% Path Error; Please Prove A Path That Exists Inside "%converted_location%"
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

if "%1" == "-remove" (
    if not "%2" == "" (
        set package_name=%2
        goto def_remove_packages
    ) else (
        echo %cmdres% Arguement Error; No Package Name Defined
        goto eof
    )
)

if "%1" == "-updatelogs" (
    echo.
    curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/updates
    goto eof
)

if "%1" == "-mypkg" (
    if not "%2" == "" (
        set package_name=%2
        goto def_pkg_bool
    ) else (
        goto def_installed_packages
    )
)

:: add arg headers before this
if not "%1" == "" (
    goto defined_error
) else (
    echo [92mUnwrap V0.4.2, A Package Manager For Scripts
    echo Please Run Unwrap "-?" for help and commands.[0m
    goto eof
)

:defined_error
echo %cmdres% Arguement Error; "%1" is Too Ambiguous
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

for %%a in ("%package_link:/=" "%") do (
    set "filenameext=%%~nxa"
)
for %%a in ("%filenameext%") do (
    set "extension=%%~xa"
)

if not errorlevel == 0 goto nopackagesfound

if not defined package_link (
    :nopackagesfound
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


:: read and convert sizes,
set size=!FILE_SIZE!
set trueSize =!FILE_SIZE!
set finalSize=0
set kb=1000
set mb=1000000
set gb=1000000000
set unit=B
if !size! gtr !gb! (
    set /a finalSize=!size! / !gb!
    set unit=GB
    goto final_convert
)
if !size! gtr !mb! (
    set /a finalSize=!size! / !mb!
    set unit=MB
    goto final_convert
)
if !size! gtr !kb! (
    set /a finalSize=!size! / !kb!
    set unit=KB
    goto final_convert
)
set finalSize=!size!
:final_convert
set FILE_SIZE=!finalSize!
:: get data for other file info
for /f "usebackq tokens=*" %%a in (`powershell -command ^
    "Get-ChildItem -Path '%converted_location%' -Recurse -File | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum"`) do (
    set "targetSizeBefore=%%a"  
)


echo The Following Package(s) Will Be Installed,
echo    File Name:     !package_name![92m!extension![0m
echo    File Size:     !FILE_SIZE![92m!unit![0m
echo    Destination:   !converted_location!
echo.
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
if exist %converted_location%\%filenameext% (
    echo [31mScript Already Exists in [92m"%converted_location%"[0m
    :choice
    set choice=l
    set /p choice=Overwrite? [y/n]: 
    if %choice%==y goto Overwrite
    if %choice%==Y goto Overwrite
    if %choice%==n goto eof
    if %choice%==N goto eof
    goto choice
)
:Overwrite
echo Installing to Path "%converted_location%"
echo.
title ━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul
powershell -command "(Get-Content "C:\users\%username%\.unwrap\.temp\%package_name%.unw") | Set-Content "C:\users\%username%\.unwrap\.temp\%filenameext%"
PING -n 1 8.8.8.8 | FIND "TTL=">nul
del "C:\users\%username%\.unwrap\.temp\%package_name%.unw"
title ━━━━━━━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul━
move "C:\users\%username%\.unwrap\.temp\%filenameext%" "%converted_location%">nul
PING -n 1 8.8.8.8 | FIND "TTL=">nul
title ━━━━━━━━━━━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul
echo memory>"C:\users\%username%\.unwrap\.temp\memory\%package_name%.mem"
timeout 3 >nul 
title ━━━━━━━━━━━━━━━━━━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul
title Finished Installing
echo.
title ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul
echo Finalizing Processes...
PING -n 1 8.8.8.8 | FIND "TTL=">nul
title ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul
echo [Checking Location]
if not exist %converted_location%\%filenameext% (
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo [Location not correct, please re-install]
) else (
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo [Location Verified]
)
PING -n 1 8.8.8.8 | FIND "TTL=">nul
echo [Verifing Data]
PING -n 1 8.8.8.8 | FIND "TTL=">nul
echo.
echo Download Finished ^!
goto eof

:def_help
::curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.visible/help
echo Usage: unwrap ^<COMMAND^> [^<ARGS...^>] [^<-ec^>]
echo.
echo COMMAND,   ARGS,         DESCRIPTION,
echo.
echo -?/-help                 shows the help menu, (this menu)
echo -init                    initialize the package manager, this is required on first boot
echo -install [PKGNAME]       install packages from the unwrap script database
echo -mypkg                   lists all packages you have installed and thier install Date
echo -mypkg   [PKGNAME]       checks actuality of a specific package, returns a bool
echo -pkglist                 lists all available packages, ~5mins from updates
echo -pkgpush [FILENAME]      upload a package to a custom database, which can be sent to main package
echo -remove  [PKGNAME]       removes a package thats installed, needs to be in "download_location"
echo -repair  [FILENAME]      use this command to repair the encoding (if a file doesnt work)
echo -search  [PKGNAME]       search for packages, if none found, try "unwrap -upt"
echo -upt                     update the packages to install
echo -updatelogs              shows all the update information, dynamic updating
echo.
echo Debugging,
echo -ec                      goes in either the second or third arguement, returns the exit code
::echo -more                    shows more information
goto eof

:def_update
for %%A in ("C:\users\%username%\.unwrap\.packages\package_links.json*") do (
    set file_date=%%~tA
    echo  Last Updated:    !file_date:~0,10!
)
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/packages.json>"C:\users\%username%\.unwrap\.temp\package_links.unw"
for %%F in ("C:\users\%username%\.unwrap\.temp\package_links.unw") do set UPDATE_FILE_SIZE=%%~zF
for %%F in ("C:\users\%username%\.unwrap\.packages\package_links.json") do set CURR_FILE_SIZE=%%~zF
echo  Size of Update:  %UPDATE_FILE_SIZE%[92mB[0m
set /a diff=!UPDATE_FILE_SIZE! - !CURR_FILE_SIZE!
echo  Size Difference: !diff![92mB[0m
echo.
:choose_cont2
set choice=""
set /p choice=Do You Want To Continue? [y/n]: 
if %choice% == y del "C:\users\%username%\.unwrap\.temp\package_links.unw" && goto update_file
if %choice% == Y del "C:\users\%username%\.unwrap\.temp\package_links.unw" && goto update_file
if %choice% == N del "C:\users\%username%\.unwrap\.temp\package_links.unw" && goto eof
if %choice% == n del "C:\users\%username%\.unwrap\.temp\package_links.unw" && goto eof
goto choose_cont2
:update_file
title Updating
PING -n 1 8.8.8.8 | FIND "TTL=">nul
title ━━━━━━━━━━━━
curl -s https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/packages.json>"C:\users\%username%\.unwrap\.packages\package_links.json"
PING -n 1 8.8.8.8 | FIND "TTL=">nul 
title ━━━━━━━━━━━━━━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul 
title ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PING -n 1 8.8.8.8 | FIND "TTL=">nul 
title ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Updates Applied
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

:def_remove_packages
if not exist %converted_location%\%filenameext% (
    echo %cmdres% Locate Error; "%package_name%" Was Not Found
) else (
    :::choice
    ::set choice=
    ::set /p choice=Remove %package_name%? [y/n] 
    ::if %choice% == y goto cont_remove
    ::if %choice% == Y goto cont_remove
    ::if %choice% == N goto eof
    ::if %choice% == n goto eof
    ::goto choice
    :cont_remove
    del %converted_location%\%package_name%>nul
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo Removing Main Program
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    del C:\users\%username%\.unwrap\.temp\memory\%package_name%.mem>nul
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo Removing Memory File
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo Removing Traces
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    echo Removing Paths
    PING -n 1 8.8.8.8 | FIND "TTL=">nul
    if %errorlevel% == 0 (
        echo %package_name% Was Successfully Removed
        goto eof
    ) else (
        echo An Error Occured
        goto eof
    )
)
goto eof
:def_installed_packages
set counter=0
echo.
echo Creation Date    Package Name
echo -----------------------------
for %%A in ("C:\users\%username%\.unwrap\.temp\memory\*") do (
    set /a counter+=1
    set file_date=%%~tA
    echo  !file_date:~0,10!      %%~nA      
)
echo.
echo    Total Packages: !counter!
goto eof

:def_pkg_bool
if exist C:\users\%username%\.unwrap\.temp\memory\%package_name%.mem (
    for %%A in ("C:\users\%username%\.unwrap\.temp\memory\%package_name%.mem*") do (
            set file_date=%%~tA
        echo Package Actuality: [92mTrue[0m
        echo Date Created:      !file_date:~0,10!
    )  
) else (
    echo Package Actuality: [91mFalse[0m
    
)
goto eof


:def_show_more
goto eof
:eof
if "%3" == "-ec" (
    echo.
    echo Exited With Code: %errorlevel%
)
if "%2" == "-ec" (
    echo.
    echo Exited With Code: %errorlevel%
)
title %username%@%computername%
