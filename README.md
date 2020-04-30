# .i3
My i3 config installation repo

## Installing
To install, simply type,
````
make
````
And then follow the instructions. Alternatively you can run
````
./install.sh
````
This will take you through the installation process, and create a `localconf`
which is identical to the one created when using `make`, the only difference
is that no symlinks and backups are made, ie your i3 configs are not touched.

## To uninstall
To uninstall and revert to your previous (if one existed) i3 config, simply type,
````
make uninstall
````
