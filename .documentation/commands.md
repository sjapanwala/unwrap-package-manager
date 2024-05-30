```
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
