# usbfilter

With these scripts you can filter which USB devices can connect to your
Linux system. For instance, allow your USB mass storage device only to
be exactly that and not one day register itself as a keyboard.

## Setup

Create `/etc/usb_whitelist`:

```
idVendor:idProduct:AllowedClass
...
```

`AllowedClass` is the [usb class code][usb class code]. For example,
use `08` for usb flash drives.

Add the following to the kernel command line (edit your boot loader
config): `usbcore.authorized_default=0`.

Make sure the following runs by init on system boot:

```sh
# usbfilter
echo 0 > /sys/bus/usb/drivers_autoprobe
echo "/usr/bin/hotplug_filter.sh" > /proc/sys/kernel/hotplug
/usr/bin/authorize_scan.sh
```

Use `/usr/bin/scan_new.sh` to see devices which aren't in the whitelist
yet.

## Licensing

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.

[usb class code]: http://www.usb.org/developers/defined_class
