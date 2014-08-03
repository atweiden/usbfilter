#!/bin/bash
cd /sys/bus/usb/devices/

ls | grep -v : | while read device ; do
idProduct=$(cat $device/idProduct)
idVendor=$(cat $device/idVendor)
grep "$idVendor:$idProduct" /etc/usb_whitelist
if [ $? -eq 0 ] ; then
echo 1 > $device/authorized
fi

done
