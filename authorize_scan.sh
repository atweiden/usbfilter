#!/bin/bash

main() {
  local idProduct
  local idVendor

  cd /sys/bus/usb/devices/ \
    || exit 1

  grep -v : -- * | while read -r device; do
    idProduct="$(cat "$device/idProduct")"
    idVendor="$(cat "$device/idVendor")"
    grep "$idVendor:$idProduct" /etc/usb_whitelist \
      && echo 1 > "$device/authorized"
  done
}

main
