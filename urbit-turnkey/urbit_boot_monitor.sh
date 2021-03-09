#!/bin/bash

if [[ `runuser -u urbit -- urbit -xt -w $1 -k $2 -c /home/urbit/urbit_pier | tee /dev/tty1 /tmp/boot_urbit.log` ]]
    then
        echo "Urbit boot complete"
        touch /home/urbit/.urbit_booted
        exit 0
    else
        echo "Urbit boot failure"
        tail -2 /tmp/boot_urbit.log > /home/urbit/boot_failure.log
        exit 1
fi
