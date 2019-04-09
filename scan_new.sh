#!/bin/bash

main() {
  local _usb_whitelist_path
  _usb_whitelist_path="/etc/usb_whitelist"
  lsusb | awk '{print $6}' | while read -r _line; do
    grep -q "$_line" "$_usb_whitelist_path" \
      || echo "$_line is not in whitelist yet"
  done
}

main
