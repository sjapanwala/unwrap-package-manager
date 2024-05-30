<p align="center">
<img src="https://github.com/sjapanwala/unwrap-package-manager/assets/92124191/151df451-49d2-49ca-948a-f22d27ea7332" width="350" lenght="350">
</p>

# <center> [Features](#what-is-unwrap) | [Commands](#commands) |  [Documentation](#documentation) | [Installation](#installation)

<p align="center">
<img src="https://img.shields.io/badge/Version-0.4.1-red">
<img src="https://img.shields.io/badge/Windows-11-green">
<img src="https://img.shields.io/badge/Windows-10-green">
</p>

## What Is Unwrap?
### Unwrap is a package manager specifically for scripts, either for CMD/Batch Scripts, Python Scripts, ETC...


## Commands

### Commands and Usage As of [Version 0.4.1]

```txt
Usage: unwrap <Command...> [<ARGS...>]
```

```txt
Prefix       Command  ARGS    


unwrap      -install [PKGNAME]  
                -> installs packages
unwrap      -init               
                -> initializes directories / (can be done in builder)
unwrap      -upt                
                -> updates packages database
unwrap      -repair [filename]  
                -> repairs a script (fixes encoding, file needs to be in same dir as in config)
unwrap      -search [PKGNAME]  
                -> searches your package link file for a specific package, user may need to update (unwrap -upt)
unwrap      -pkgpush [FILENAME] 
                -> push a userbuilt script to the package database
                - more: 
                    - makes a custom package json file 
                    - with current packages and your packages
                    - make sure to (unwrap -upt) before (unwrap -pkgpush)
                    - !! REQUIRES UNWRAP_PY_PUSH.py !!
unwrap      -pkglist             -> lists all the packages in the json link file, your packages and source packages may not be aligned
```
## Documentation
### [📁 File Structuring](https://github.com/sjapanwala/unwrap-package-manager/blob/main/.documentation/filestructure.md)
### [⌨️ Commands](https://github.com/sjapanwala/unwrap-package-manager/blob/main/.documentation/commands.md)

## Installation

### Easy Installation Using Unwrap-Builder
```cmd
curl https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/builder.cmd -o unwrap_builder.cmd
```
- **All files will be downloaded in the current directory user is working in (this should not be a big issue)**
1) run the script
2) your file will be created as "unwrap.cmd"
3) for global usage; move this file into `C:\Windows\`

### Installing Using Main File, 2-Part Process
#### Part 1
- **You Will Need To Be Working In The Same Dir**
1) Enter This Command Into Your Terminal
```cmd
curl https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/unwrap.cmd -o unwrap.cmd
```
2) You Will need to `Patch` the script in order for it to run (convert it to [CR LF])
#### Part 2
3) Enter this command
```cmd
curl https://raw.githubusercontent.com/sjapanwala/unwrap-package-manager/main/.packages/repair.cmd -o repair.cmd
```
4) Run this script in the same Dir either with 
```cmd
C:\> repair unwrap.cmd

::      or

C:\> repair.cmd
:: follow the steps given in the script
```
5) for global usage; move this file to `C:\Windows\`


