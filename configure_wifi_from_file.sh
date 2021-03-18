#!/bin/bash

dos2unix /media/usb/wifi.txt

SSID="$(awk "NR==1{print;exit}" /media/usb/wifi.txt)"
PASSWORD="$(awk "NR==2{print;exit}" /media/usb/wifi.txt)"

if [[ -z "$PASSWORD" ]]
    then nmcli device wifi connect "$SSID"
    else nmcli device wifi connect "$SSID" password "$PASSWORD"
fi
