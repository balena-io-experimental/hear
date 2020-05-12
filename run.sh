#!/bin/bash

OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

modprobe i2c-dev

mod_dir="seeed-voicecard_${BALENA_DEVICE_TYPE}_${OS_VERSION}"
echo "Loading snd-soc-simple-card first..."
modprobe snd-soc-core snd-soc-simple-card
echo "Loading module from $mod_dir"
insmod $mod_dir/snd-soc-ac108.ko
insmod $mod_dir/snd-soc-seeed-voicecard.ko
lsmod | grep snd

while true; do
	sleep 60
done
