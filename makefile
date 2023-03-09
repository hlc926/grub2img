# makefile
#

cfg = init.cfg memdisk/grub2img.cfg

efi = grub2img.efi
ldr = grub2img.ldr
pc = core.img

modcommon = help ls echo cat search file linux boot reboot halt tar xzio gfxterm memdisk map minicmd configfile loopback part_gpt part_msdos iso9660 udf ext2 xfs exfat fat ntfs sleep test regexp expr version gzio lzopio cpio stat true tr chain extcmd normal fb net http tftp lspci lsmmap mmap

modefi = $(modcommon) linuxefi efi_gop efi_uga lvm part_apple part_bsd btrfs reiserfs affs afs bfs f2fs hfs hfsplus jfs zfs

modpc = $(modcommon) ntldr linux16 biosdisk vbe vga

all: $(efi) $(ldr)

$(efi): $(cfg)
	if [ ! -d 'files/grub' ]; then echo "sh get_files.sh"; exit 1;  fi
	rm -rf build
	mkdir build
	cp -ar memdisk build/
	rm -rf build/memdisk/pc
	cd build/memdisk/; tar --xz -cf ../memdisk.tar.xz . ; cd ../..
	grub2-mkimage -m build/memdisk.tar.xz -c init.cfg -p'/boot/grub2img' -O x86_64-efi -d files/grub/x86_64-efi/ -o $(efi) $(modefi)
	rm -rf build


$(ldr): $(cfg)
	if [ ! -d 'files/grub' ]; then echo "sh get_files.sh"; exit 1;  fi
	if [ ! -d 'files/grub4dos' ]; then echo "sh get_files.sh"; exit 1;  fi
	rm -rf build
	mkdir build
	cp -ar memdisk build/
	rm -rf build/memdisk/efi
	cp -f files/grub4dos/grub.exe build/memdisk/pc/
	cd build/memdisk/; tar --xz -cf ../memdisk.tar.xz . ; cd ../..
	grub2-mkimage -m build/memdisk.tar.xz -c init.cfg -p'/boot/grub2img' -O i386-pc -d files/grub/i386-pc/ -o $(pc) $(modpc)
	cat /usr/lib/grub/i386-pc/lnxboot.img $(pc) > $(ldr)
	rm -f $(pc)
	rm -rf build

clean: 
	rm -f $(efi) $(ldr) $(pc)

