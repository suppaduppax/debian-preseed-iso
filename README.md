# debian-preseed-iso
Make re-mastered debian ISOs with preseed file.

Original script by: zuzzas \
https://gist.github.com/zuzzas/a1695344162ac7fa124e15855ce0768f

ISO boot tested on ESXi 6.7u3 using bios boot.

## The Journey
There isn't very extensive documentation on re-mastering debian ISOs and the documentation that's there isn't very clear. Hopefully this clears up some things I've learned when trying to make a preseeded debian ISO.

I've tried following the wiki for embedding the preseed file inside initrd using this guide: `https://wiki.debian.org/DebianInstaller/Preseed/EditIso`\
That was unsuccessful.

The approach that worked for me was adding the preseed file in the root directory and editing boot parameters inside `isolinux/isolinux.cfg` to use it.
There were other scripts and guides that modified `isolinux/txt.cfg` to include the preseed file but after many hours of failure, it seemed like it wasn't using txt.cfg on boot.

## Using the script
### Prepare your seed file.
Modify the `preseed.cfg` file to suit your needs. It takes a little bit of research to figure out exactly what each line does.
