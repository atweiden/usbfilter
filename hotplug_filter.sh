#!/bin/bash
env >> /tmp/hotpluglog
echo $SUBSYSTEM
if [ "$SUBSYSTEM" = "usb" ] ; then

	if [ "$ACTION" != "add" ] ; then
		exit
	fi

	if [ "$DEVTYPE" = "usb_device" ] ; then
		cd /sys/$DEVPATH/
	fi

	if [ "$DEVTYPE" = "usb_interface" ] ; then
		cd /sys/$DEVPATH/..
	fi

	port=$(basename $DEVPATH)
	idProduct=$(cat idProduct)
	idVendor=$(cat idVendor)
	bInterfaceClass=""
	search=""


	if [ "$DEVTYPE" = "usb_device" ] ; then
		search="$idVendor:$idProduct"
	fi

	if [  "$DEVTYPE" = "usb_interface" ] ; then
		cd /sys/$DEVPATH/
		bInterfaceClass=$(cat bInterfaceClass)
		search="$idVendor:$idProduct:$bInterfaceClass"
	fi
	echo $search >> /tmp/search
	grep -q $search /etc/usb_whitelist
	if [ $? -ne 0 ] ; then
		echo "denied $DEVPATH" >> /tmp/denied_log
		exit
	fi
	[ -e /sys/$DEVPATH/authorized ] && echo 1 > /sys/$DEVPATH/authorized
	echo "$port" > /sys/bus/usb/drivers_probe
fi
