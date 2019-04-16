#!/bin/bash
#	How to change the anaconda-ks.cfg to auto install text confiure
# 1. If find the "Use graphical install" is graphical, change the graphical to text
# 2. "Partition clearing information", if will install OS into sda, should setting as: clearpart --all --initlabel --drives=sda
# 3. "Disk partitioning information" should make partitions plan according to the actual hard disk.
# 4. If want auto reboot after install OS, should insert the reboot before %packages
#
#	How to run this command:
# ./mk.USB-auto-install-CentOS.sh /dev/sdX /dev/sdY anaconda-ks.xxx.cfg
#
#	Note:
# In some servers, the allocation of device number of hard disk and USB disk is random and not fixed after each power-on.
# If USB disk is scanned and allocated /dev/sda first, the conflict will lead to the failure of automatic installation and stop,
# and manual intervention is needed to select the installation target disk.

function PromptForYesOrNo() {
  while true; do
    read input
    if [[ x"$input" == x"yes" ]]; then
      return 0
    elif [[ x"$input" == x"no" ]]; then
      return 1
    else
      echo -n "Please type \"yes\" or \"no\": "
    fi
  done
  return 1
}

if [ ! -n "$1" ] ; then
  echo "args error: arg1 should be original ISO file or dev!"
fi

if [ ! -n "$2" ] ; then
  echo "args error: arg2 should be target dev!"
fi

if [ ! -n "$3" ] ; then
  echo "args error: arg3 should be kickstart config file!"
fi
echo "It will format the $2 as fat32 and set label, then copy $3 and all of files in $1 to $2, modify the grub.cfg in $2"
echo -n "Do you confirm this dangerous operation? Type \"yes\" or \"no\": "
if PromptForYesOrNo; then
  echo "For a long time, don't interrupt..."
else
  echo "cancel..."
  exit 0
fi

umount tmp.usb.iso
umount tmp.usb.target
rm -rf tmp.usb.iso tmp.usb.target
mkdir tmp.usb.iso tmp.usb.target

#delete 10 partition and create a new partition, change the partition id to fat32, then format partition and set the label
echo -e "p\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\np\nn\n\n\n\n\np\nw\n" | fdisk  ${2}
echo -e "p\nt\nl\nb\nw\n" | fdisk  ${2}
mkfs.fat ${2}1
dosfslabel ${2}1 CENTOSMT

mount $1 tmp.usb.iso
mount ${2}1 tmp.usb.target
rsync -tr tmp.usb.iso/ tmp.usb.target
# just for test #cp tmp.usb.iso/EFI tmp.usb.target/ -rf
sync

cp $3 tmp.usb.target/EFI/BOOT/
sed -i 's/set default="1"/set default="0"/g' tmp.usb.target/EFI/BOOT/grub.cfg
sed -i 's/set timeout=60/set timeout=5/g' tmp.usb.target/EFI/BOOT/grub.cfg
sed -i "/### BEGIN/a\menuentry 'Install CentOS 7 - for maituan' --class red --class gnu-linux --class gnu --class os {\n linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=CENTOSMT ro inst.ks=hd:LABEL=CENTOSMT:/EFI/BOOT/$3 inst.text\n initrd /images/pxeboot/initrd.img\n}" tmp.usb.target/EFI/BOOT/grub.cfg
umount tmp.usb.target
umount tmp.usb.iso
echo "USB auto install CentOS create finish! The default user/passwd: root/root"

