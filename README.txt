This set of scripts is experimental

info
====
With these scripts you can filter which USB devices can connect to your linux
system. For instance, allow your usb mass-storage device only to be exactly
that and not one day register itself as a keyboard... 

Setup
=====
Create /etc/usb_whitelist:
idVendor:idProduct:AllowedClass
...

"AllowClass" is the usb class code [1]. For example, use 08 for usb flash drives.

Add the following to the kernel command line (edit your boot loader config): usbcore.authorized_default=0

Make sure the following runs by init on system boot:

echo 0 > /sys/bus/usb/drivers_autoprobe
echo "/sbin/hotplug_filter.sh" > /proc/sys/kernel/hotplug
/sbin/authorize_scan.sh

Use scan_new.sh to see devices which aren't in the whitelist yet.

Resources
=========
[1] List of classes: http://www.usb.org/developers/defined_class
