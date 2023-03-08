# grub2img
grub2 in one image (include boot iso files)


###  make

    git clone ...
    sh get_files.sh u   # update grub2 and grub4dos
    sh get_files.sh x   # eXtract
    make clean; make    # you will get grub2img.efi(x86_64-efi) and grub2img.ldr(i386-pc)

### usage

##### grub2

    menuentry 'grub2img' {
        set root=(hd0,3)    # replace to yours
        if [ "${grub_platform}" = "pc" ]; then
            ntldr /boot/grub2img/grub2img.ldr   # replace to your directory
        else
            chainloader /boot/grub2img/grub2img.efi  # replace to your directory
        fi
    }

##### windows10 (x86_64-efi)

    cd /EFI/BOOT/
    mv bootx64.efi bootx64.efi.win10
    cp grub2img.efi bootx64.efi     
        # BIOS UEFI -> bootx64.efi(grub2img.efi) -> bootmgfw.efi(windows10)

##### windows10 (i386-pc)

    mv bootmgr bootmgr.win10
    cp grub2img.ldr bootmgr
        # BIOS -> bootmgr(grub2img.ldr) -> bootmgr.win10(windows10)


##### grub2img.cfg (windows10 example)

    cd /Boot
    mkdir grub2img; cd grub2img
    vi grub2img.cfg : 
        #########################
        default=0
        timeout=10
        
        menuentry 'win10' {
            set root=(hd0,1)        # replace to yours
            if [ "${grub_platform}" = "pc" ]; then
                ntldr /bootmgr.win10
            else
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            fi
        }
        
        menuentry 'default' {
            configfile ${mcfg}
        }
        #########################


