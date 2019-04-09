# usbfilter

Control which USB devices can connect to your Linux machine.

Allow your USB mass storage device only to be exactly that, and not one
day register itself as a keyboard.

## Setup

Create `/etc/usbfilter/whitelist`:

```
$id_vendor:$id_product:$allowed_class
...
...
```

`$allowed_class` is the [USB class code][USB class code]. For example,
use `08` for USB flash drives.

Add the following to the kernel command line (edit your boot loader
config): `usbcore.authorized_default=0`.

Ensure the following runs on system startup:

```sh
echo 0 > /sys/bus/usb/drivers_autoprobe
echo '/usr/bin/usbfilter hotplug' > /proc/sys/kernel/hotplug
/usr/bin/usbfilter scan --authorized
```

Use `usbfilter scan --new` to see devices which aren't in the whitelist
yet.

## Licensing

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.

[USB class code]: http://www.usb.org/developers/defined_class
