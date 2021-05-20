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
} # Main

CheckForExistingUrbit() {
	echo "Testing for pre-exiting Urbit"
	if [[ -f /home/urbit/.urbit_booted ]]
		then
			echo "Urbit already booted on this device" >&2 
			exit 3 
		else
			echo "No previous Urbit boot attempt found, proceeding"
	fi
} # CheckForExistingUrbit

SetVariablesFromKeyfile() {
	KEYFILE=`ls /media/usb/*.key | head -1`
	PIER_NAME=`echo $KEYFILE | grep -Po "(?!.*\/).*" | grep -Po ".*-"`
	PIER_NAME=${PIER_NAME:0:-1}
} # SetVariablesFromKeyfile

TestNetwork() {
	echo "Testing network"
	if fping urbit.org 2>/dev/null | grep -q alive
		then
			echo "urbit.org is alive"
		else
			echo "Unable to boot Urbit successfully, network down" >&2
			exit 4
	fi
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
