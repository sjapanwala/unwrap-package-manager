# File Structure As Of Version 0.4.1
```txt
.unwrap (root directory)
├── (.packages\)
│   └── package_links.json
├── (.config\)
│   └── config.json
└── (.temp_vol\)
    ├── memory\
    │   └──(memory file in .mem format)
    └── (raw files in .unw format)
```
# If File Structure Is Altered or Directories are Removed, You Can Use `unwrap -init` to Re-Structure Directories

## `.unwrap` Directory
- This is the root directory where all the files and directories are stored under this directory
- Stored in `C:\Users\<YOURUSERNAME>\`
- Contains 
    * .packages
    * .config
    * .temp_vol
## `.packages` Directory
- Stores json file with the packages and thier links
- files are updates here
- deleting this file will require `unwrap -init` again
## `.config` Directory
- Stores json file for the configuration
- as of `Version 0.4.1` the only configuration is `"download_location":` if user knows how to alter the location, you may, but if it doesnt work, packages are not abled to beinstalled. re-structuring may be required if broken.
## `.temp_vol` Directory
- Stores Temporary Files
- files will be deleted and reinstalled in this location only
- will hold temporary files (.unw) files (is used to show file attributes without actually installing any files)
    * memory/
        * Will store memory files
        * these files will instruct the program on which programs have been installed, for package installer.
    
