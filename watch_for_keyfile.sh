#!/bin/bash

counter=0
wifi_configured=0
while [[ $counter -le 100 ]]
do
        if [[ -f /media/usb/wifi.txt && $wifi_configured -eq 0 ]]
                then
                        echo "wifi config file detected, attemping to configure wifi"
                        /usr/bin/configure_wifi_from_file.sh
                        wait
                        ((wifi_configured++))
        elif ls /media/usb/*.key &> /dev/null
                then
                        echo "urbit keyfile detected"
                        /usr/bin/boot_urbit_with_keyfile.sh
                        exit
        else
                        sleep 3
                        ((counter++))
        fi
done
echo "urbit keyfile watch timed out"
