#!/bin/bash

main() {
  lsusb | awk '{print $6}' | while read -r line; do
    grep -q "$line" /etc/usb_whitelist \
      || echo "$line is not in whitelist yet"
  done
}

main
