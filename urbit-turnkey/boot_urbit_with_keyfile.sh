#!/bin/bash

# Exit codes:
# 	3 = Urbit already booted on this device
#	4 = Unable to boot Urbit successfully, network down
#	5 = Error during Urbit boot

Main() {
	CheckForExistingUrbit
	SetVariablesFromKeyfile
	TestNetwork
	UpgradeUrbit
	BootUrbit
	EnableUrbitService
	StartUrbitService
} # Main

CheckForExistingUrbit() {
	[[ -f /home/urbit/.urbit_booted ]] && \
		(echo "Urbit already booted on this device" >&2 ; exit 3)
} # CheckForExistingUrbit

SetVariablesFromKeyfile() {
	KEYFILE=`ls /media/usb/*.key | head -1`
	PIER_NAME=`echo $KEYFILE | grep -Po "(?!.*\/).*" | grep -Po ".*-"`
	PIER_NAME=${PIER_NAME:0:-1}
} # SetVariablesFromKeyfile

TestNetwork() {
	fping urbit.org 2>/dev/null | grep -q alive || \
		(echo "Unable to boot Urbit successfully, network down" >&2 ; exit 4)
} # TestNetwork

UpgradeUrbit() {
	echo "Trying to upgrade Urbit related packages"
	export DEBIAN_FRONTEND=noninteractive
	export APT_LISTCHANGES_FRONTEND=none
	apt-get update
	apt-get --only-upgrade install urbit urbit-service urbit-turnkey
} # UpgradeUrbit

BootUrbit() {
	echo "Starting Urbit boot"
	if [[ `/usr/bin/urbit_boot_monitor.sh $PIER_NAME $KEYFILE` ]]
		then
			EnableUrbitService
			StartUrbitService
		else
			exit 5
	fi
} # BootUrbit

EnableUrbitService() {
	echo "Enabling Urbit service"
	systemctl enable urbit-service
} # EnableUrbitService

StartUrbitService() {
	echo "Starting Urbit service"
	systemctl start urbit-service
} # StartUrbitService

Main
