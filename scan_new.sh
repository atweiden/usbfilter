#!/bin/bash
lsusb | awk '{print $6}' | while read line ; do
grep -q "$line" /etc/usb_whitelist || echo "$line is not in whitelist yet"
done
