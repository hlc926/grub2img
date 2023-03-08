#!/usr/bin/bash

if [ "$1" != "u" ] && [ "$1" != "x" ] && [ "$1" != "a" ] ; then
	echo "sh $0 <cmd>"
	echo "cmd:"
	echo "    u : for update grub2 and grub4dos"
	echo "    x : for eXtract"
	echo "    a : for update and eXtract"
	exit;
fi

if [ ! -d 'files' ]; then 
	mkdir files
fi

cd files; 

if [ "$1" = "u" ] || [ "$1" = "a" ] ; then
	rm -f grub2-*.gz grub4dos-*.7z
	wget -4 https://github.com/a1ive/grub/releases/download/latest/grub2-latest.tar.gz
	wget -4 $(curl -s https://api.github.com/repos/chenall/grub4dos/releases/latest | grep browser_download_url | cut -d '"' -f 4)
fi 

if [ "$1" = "x" ] || [ "$1" = "a" ] ; then
	rm -rf `ls -F | grep "/$"`	# delete directory
	tar -xf grub2-latest.tar.gz 
	7za x `ls -tr grub4dos-*.7z | tail -1`
	mv `ls -d grub4dos-* | grep -v "7z"` grub4dos
fi

cd ..

