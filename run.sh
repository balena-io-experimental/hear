#!/bin/bash

#set kernel modules
grep -q "^snd-soc-seeed-voicecard$" /etc/modules || \
  echo "snd-soc-seeed-voicecard" >> /etc/modules
grep -q "^snd-soc-ac108$" /etc/modules || \
  echo "snd-soc-ac108" >> /etc/modules
grep -q "^snd-soc-wm8960$" /etc/modules || \
  echo "snd-soc-wm8960" >> /etc/modules

OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

modprobe i2c-dev

mod_dir="seeed-voicecard_${BALENA_DEVICE_TYPE}_${OS_VERSION}.dev"
echo "Loading snd-soc-simple-card first..."
modprobe snd-soc-simple-card
echo "Loading modules from $mod_dir"
insmod $mod_dir/snd-soc-ac108.ko
insmod $mod_dir/snd-soc-seeed-voicecard.ko
insmod $mod_dir/snd-soc-wm8960.ko
lsmod | grep snd

ln -s /etc/voicecard/asound_4mic.conf /etc/asound.conf
ln -s /etc/voicecard/ac108_asound.state /var/lib/alsa/asound.state
alsactl restore
amixer cset numid=3 1

while true; do
	sleep 60
done
