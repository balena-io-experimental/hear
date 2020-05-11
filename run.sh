#!/bin/bash

OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

modprobe i2c-dev

mod_dir="seeed-voicecard_${BALENA_DEVICE_TYPE}_${OS_VERSION}*"
echo "Loading snd-soc-simple-card first..."
modprobe snd-soc-simple-card
for each in $mod_dir; do
	echo Loading module from "$each"
	insmod "$each/snd-soc-ac108.ko"
	insmod "$each/snd-soc-wm8960.ko"
	insmod "$each/snd-soc-seeed-voicecard.ko"
	lsmod | grep snd-soc-seeed-voicecard
	#rmmod snd-soc-seeed-voicecard
done

while true; do
	sleep 60
done
