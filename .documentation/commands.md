Usage: unwrap <COMMAND> [<ARGS...>] [<-ec>]

COMMAND,   ARGS,         DESCRIPTION,

-?/-help                 shows the help menu, (this menu)
-init                    initialize the package manager, this is required on first boot
-install [PKGNAME]       install packages from the unwrap script database
-mypkg                   lists all packages you have installed and thier install Date
-mypkg   [PKGNAME]       checks actuality of a specific package, returns a bool
-pkglist                 lists all available packages, ~5mins from updates
-pkgpush [FILENAME]      upload a package to a custom database, which can be sent to main package
-remove  [PKGNAME]       removes a package thats installed, needs to be in "download_location"
-repair  [FILENAME]      use this command to repair the encoding (if a file doesnt work)
-search  [PKGNAME]       search for packages, if none found, try "unwrap -upt"
-upt                     update the packages to install
-updatelogs              shows all the update information, dynamic updating

Debugging,
-ec                      goes in either the second or third arguement, returns the exit code
