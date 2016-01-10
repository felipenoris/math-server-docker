# Instructions on how to setup Raspberry Pi

## Install image on mac
https://www.raspberrypi.org/documentation/installation/installing-images/mac.md

list partitions:
	diskutil list
Identify the disk (not partition) of your SD card e.g. disk4 (not disk4s1)

Unmount your SD card by using the disk identifier to prepare copying data to it: 
	diskutil unmountDisk /dev/disk<disk# from diskutil>

	Unmount your SD card by using the disk identifier to prepare copying data to it:

diskutil unmountDisk /dev/disk<disk# from diskutil>

e.g. diskutil unmountDisk /dev/disk4

Copy the data to your SD card:

sudo dd bs=1m if=image.img of=/dev/rdisk<disk# from diskutil>

e.g. sudo dd bs=1m if=2015-11-21-raspbian-jessie.img of=/dev/rdisk4

This may result in an dd: invalid number '1m' error if you have GNU coreutils installed. In that case you need to use 1M:

sudo dd bs=1M if=image.img of=/dev/rdisk<disk# from diskutil>

This will take a few minutes, depending on the image file size. You can check the progress by sending a SIGINFO signal pressing Ctrl+T.

If this command still fails, try using disk instead of rdisk:

e.g. `sudo dd bs=1m if=2015-11-21-raspbian-jessie.img of=/dev/disk4`
or

e.g. `sudo dd bs=1M if=2015-11-21-raspbian-jessie.img of=/dev/disk4`

## raspi-config from X11

menu->preferences->Raspberry Pi Configuration -> Localisation -> Set Keyboard
menu->preferences->Raspberry Pi Configuration-> Change Password

obs.: default user login is pi, password raspberry

## Connet to network

From X11, click on right top corner network icon to choose network.

## raspi-config

sudo raspi-config

expand filesystem
set overclock medium 900MHz
set boot options B1 Console (requiring user to login)

reboot

obs.: use 'startx' on command line to go to X11 from terminal.

## Fix wifi stability
http://docs.brewpi.com/installing-your-pi/rpi-setup.html

Create a new file 8192cu.conf in /etc/modprobe.d/:
sudo nano /etc/modprobe.d/8192cu.conf
Add this line to the file and save:
options 8192cu rtw_power_mgnt=0 rtw_enusbss=0

then reboot

## add swap space

http://raspberrypi.stackexchange.com/questions/70/how-to-set-up-swap-space

Raspbian uses dphys-swapfile, which is a swap-file based solution instead of the "standard" swap-partition based solution. It is much easier to change the size of the swap.

The configuration file is:

/etc/dphys-swapfile

The content is very simple. By default my Raspbian has 100MB of swap:

CONF_SWAPSIZE=100

If you want to change the size, you need to modify the number and restart dphys-swapfile:


/etc/init.d/dphys-swapfile stop
/etc/init.d/dphys-swapfile start

Edit: On Raspbian the default location is /var/swap, which is (of course) located on the SD card. I think it is a bad idea, so I would like to point out, that the /etc/dphys-swapfile can have the following option too: CONF_SWAPFILE=/media/btsync/swapfile

I only problem with it, the usb storage is automounted, so a potential race here (automount vs. swapon)

## update firmware

Run 'sudo rpi-update' if using Pi for the first time to update firmware.

## Disable blank screen (power saving)
http://raspberrypi.stackexchange.com/questions/752/how-do-i-prevent-the-screen-from-going-blank

sudo sh -c "TERM=linux setterm -blank 0 >/dev/tty0"
