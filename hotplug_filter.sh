#!/bin/bash

main() {
  env >> /tmp/hotpluglog

  echo "$SUBSYSTEM"

  if [[ "$SUBSYSTEM" == "usb" ]]; then
    [[ "$ACTION" != "add" ]] \
      && exit
    [[ "$DEVTYPE" == "usb_device" ]] \
      && (cd "/sys/$DEVPATH/" || exit 1)
    [[ "$DEVTYPE" == "usb_interface" ]] \
      && (cd "/sys/$DEVPATH/.." || exit 1)

    port="$(basename "$DEVPATH")"
    idProduct="$(cat idProduct)"
    idVendor="$(cat idVendor)"
    bInterfaceClass=""
    search=""

    [[ "$DEVTYPE" == "usb_device" ]] \
      && search="$idVendor:$idProduct"

    if [[ "$DEVTYPE" == "usb_interface" ]]; then
      (cd "/sys/$DEVPATH/" || exit 1)
      bInterfaceClass="$(cat bInterfaceClass)"
      search="$idVendor:$idProduct:$bInterfaceClass"
    fi

    echo "$search" >> /tmp/search

    if [[ "$(grep -q "$search" /etc/usb_whitelist)" -ne 0 ]]; then
      echo "denied $DEVPATH" >> /tmp/denied_log
      exit
    fi

    [[ -e "/sys/$DEVPATH/authorized" ]] \
      && echo 1 > "/sys/$DEVPATH/authorized"

    echo "$port" > /sys/bus/usb/drivers_probe
  fi
}

main
