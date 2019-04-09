#!/bin/bash

main() {
  local _log_hotplug_path
  local _search_path
  local _usb_whitelist_path
  local _denied_log_path

  local _port
  local _id_product
  local _id_vendor
  local _b_interface_class
  local _search

  _log_hotplug_path="/tmp/hotpluglog"
  _search_path="/tmp/search"
  _usb_whitelist_path="/etc/usb_whitelist"
  _denied_log_path="/tmp/denied_log"

  env >> "$_log_hotplug_path"

  echo "$SUBSYSTEM"

  if [[ "$SUBSYSTEM" == "usb" ]]; then
    [[ "$ACTION" != "add" ]] \
      && exit
    [[ "$DEVTYPE" == "usb_device" ]] \
      && (cd "/sys/$DEVPATH/" || exit 1)
    [[ "$DEVTYPE" == "usb_interface" ]] \
      && (cd "/sys/$DEVPATH/.." || exit 1)

    _port="$(basename "$DEVPATH")"
    _id_product="$(cat idProduct)"
    _id_vendor="$(cat idVendor)"

    if [[ "$DEVTYPE" == "usb_device" ]]; then
      _search="$_id_vendor:$_id_product"
    fi

    if [[ "$DEVTYPE" == "usb_interface" ]]; then
      (cd "/sys/$DEVPATH/" || exit 1)
      _b_interface_class="$(cat bInterfaceClass)"
      _search="$_id_vendor:$_id_product:$_b_interface_class"
    fi

    echo "$_search" >> "$_search_path"

    grep -q "$_search" "$_usb_whitelist_path" \
      || (echo "denied $DEVPATH" >> "$_denied_log_path"; exit)

    [[ -e "/sys/$DEVPATH/authorized" ]] \
      && echo 1 > "/sys/$DEVPATH/authorized"

    echo "$_port" > /sys/bus/usb/drivers_probe
  fi
}

main
