# Linux Cleanup

This is a collection of scripts that delete all packages except those specified in the `pkgs.base` file.

**Note**: This does NOT delete existing configuration files, only the packages.

## How to use

Download the appropriate script and run it in the same directory as your `pkgs.base`.
The package list included is a sample based on a BlackArch minimal installation and can be replaced by any "barebones" package list of your choice.
If you want to generate a "base" package list, run the appropriate command for your distribution:

```
pacman -Q | awk '{ print $1 }' > pkgs.base
dpkg --get-selections | grep -v deinstall | awk '{ print $1 }'
```

Any comments are welcome.
