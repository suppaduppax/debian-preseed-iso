# debian-preseed-iso
Make re-mastered debian ISOs with preseed file.

Original script by: zuzzas \
https://gist.github.com/zuzzas/a1695344162ac7fa124e15855ce0768f

ISO boot tested on ESXi 6.7u3 using bios boot.

# Table of Contents
* [The Journey](#the-journey)
* [Using the script](#using-the-script)
    * [Prepare the preseed.cfg file](#prepare-the-preseedcfg-file)
    * [Prepare the isolinux.cfg file](#prepare-the-isolinuxcfg-file)
    * [Customize the make-iso.sh script](#customize-the-make-isosh-script)
* [Run the installer](#run-the-installer)

# The Journey
There isn't very extensive documentation on re-mastering debian ISOs and the documentation that's there isn't very clear. Hopefully this clears up some things I've learned when trying to make a preseeded debian ISO.

I've tried following the wiki for embedding the preseed file inside initrd using this guide: `https://wiki.debian.org/DebianInstaller/Preseed/EditIso`\
That was unsuccessful.

The approach that worked for me was adding the preseed file in the root directory and editing boot parameters inside `isolinux/isolinux.cfg` to use it.
There were other scripts and guides that modified `isolinux/txt.cfg` to include the preseed file but after many hours of failure, it seemed like it wasn't using txt.cfg on boot.

# Using the script
## Prepare the preseed.cfg file.
Use the `example-preseed.cfg` file to make a `preseed.cfg` file and modify it to suit your needs. If you already have one, just copy it to the working directory. If you have never made a preseed.cfg file, it takes a little bit of research to figure out exactly what each line does.

## Prepare the isolinux.cfg file
Modify the `isolinux.cfg` file with your default hostname and domain. If those config lines are removed, you want to be prompted during install.
```
...
label install
    menu label ^Install
    menu default
    kernel /install.amd/vmlinuz
    append vga=788 initrd=/install.amd/initrd.gz
    append auto=true
    append netcfg/get_hostname=debian-autoinst
    append netcfg/get_domain=home
    append file=/cdrom/preseed.cfg
```
Change the `netcfg/get_hostname` and `netcfg/get_domain` values to fit your environment.

## Customize the make-iso.sh script
Change these values to suit your needs:
```
ISOARCH="amd64"
ISO_BASE_URL="https://cdimage.debian.org/debian-cd/current/$ISOARCH/iso-cd/"
ISOFILE="$(curl -s $ISO_BASE_URL | grep -oe debian-[0-9.-]*amd64-netinst.iso | head -1)"
ISOFILE_FINAL="autoinstall-$ISOFILE"
ISODIR=debian-iso
ISODIR_WRITE="$ISODIR-rw/"
```
| variable | description |
| --- | --- |
| ISOARCH | the architecture of the installer. Defaults: amd64
| ISO_BASE_URL | the base url of the installer iso. 
| ISOFILE | the script searches the base url of debian iso page. Usually the page contains several versions of the iso and includes the hashes.
| ISOFILE_FINAL | the output iso file you want in the end. Default uses the ISOFILE and prepends `autoinstall-` to it. ie. `autoinstall-debian-10.10.01-amd64-netinst.iso`
| ISODIR | the directory name to mount the downloaded iso to
| ISODIR_WRITE | the directory name of the copied iso mount directory. By default, the way the script mounts the iso makes the entire directory and its contents readonly. The script copies the entire directory to a new one that is writable.

# Run the installer
Run the script using 
```./make-iso```
The script takes a few seconds to complete and you w


[Headers](#the-journey)
