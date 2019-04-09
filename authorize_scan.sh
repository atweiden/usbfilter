#!/bin/bash

main() {
  local _id_product
  local _id_vendor
  local _usb_whitelist_path

  _usb_whitelist_path="/etc/usb_whitelist"

  cd /sys/bus/usb/devices/ \
    || exit 1

  grep -v : -- * | while read -r _device; do
    _id_product="$(cat "$_device/idProduct")"
    _id_vendor="$(cat "$_device/idVendor")"
    grep "$_id_vendor:$_id_product" "$_usb_whitelist_path" \
      && echo 1 > "$_device/authorized"
  done
}

main
