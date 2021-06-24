#!/bin/bash

# modified from origial version:
# https://gist.github.com/zuzzas/a1695344162ac7fa124e15855ce0768f

# exit on anything that doesnt return true
set -e
set -u

ISOARCH="amd64"
ISO_BASE_URL="https://cdimage.debian.org/debian-cd/current/$ISOARCH/iso-cd/"
ISOFILE="$(curl -s $ISO_BASE_URL | grep -oe debian-[0-9.-]*$ISOARCH-netinst.iso | head -1)"
ISOFILE_FINAL="autoinstall-$ISOFILE"
ISODIR=debian-iso
ISODIR_WRITE="$ISODIR-rw/"

wget -nc -O $ISOFILE $ISO_BASE_URL$ISOFILE || true

echo 'mounting ISO9660 filesystem...'
# source: http://wiki.debian.org/DebianInstaller/ed/EditIso
[ -d $ISODIR ] || mkdir -p $ISODIR
sudo mount -o loop $ISOFILE $ISODIR

echo 'copying to writable dir...'
rm -rf $ISODIR_WRITE || true
[ -d $ISODIR_WRITE ] || mkdir -p $ISODIR_WRITE
cp -rT "$ISODIR/" "$ISODIR_WRITE"

echo 'unmount iso dir'
sudo umount $ISODIR

echo 'correcting permissions...'
chmod 755 -R $ISODIR_WRITE

echo 'copying preseed file...'
cp preseed.cfg $ISODIR_WRITE/preseed.cfg

echo 'copying isolinux file...'
cp isolinux.cfg $ISODIR_WRITE/isolinux/isolinux.cfg

#echo 'edit isolinux/txt.cfg...'
#sed 's/initrd.gz/initrd.gz auto priority=critical netcfg\/get_domain?=home netcfg\/hostname?=debian-autoinst file=\/cdrom\/preseed.cfg locale=en_US console-setup\/ask_detect=false console-setup\/layout=us splash noprompt noshell/' -i $ISODIR_WRITE/isolinux/txt.cfg

echo 'fixing MD5 checksums...'
pushd $ISODIR_WRITE
  md5sum $(find -type f) > md5sum.txt
popd

echo 'making ISO...'
sudo genisoimage -o $ISOFILE_FINAL \
   -r -J -no-emul-boot -boot-load-size 4 \
   -boot-info-table \
   -b isolinux/isolinux.bin \
   -c isolinux/boot.cat ./$ISODIR_WRITE

# and if that doesn't work:
 # http://askubuntu.com/questions/6684/preseeding-ubuntu-server
