Trying to make the Respeaker Microphone work on a balena device. I use Respeaker 4 Mic Array and Raspberrypi 4.

## Copy the device tree overlays before flashing
1. Download an RPi image from the dashboard

2. Extract the image archive

3. Create a loop device from your image
```shell
$ sudo losetup -fP balena-name-image.img
```

4. Mount the boot partition of your image
```shell
$ mkdir tmp-mount
$ lsblik -f
$ sudo mount /dev/loop33p1 tmp-mount
```

5.Copy the dtbo in the boot partition
```shell
$ sudo cp seeed-voicecard/seeed-4mic-voicecard.dtbo tmp-mount/overlays/
```

6. Edit the config.txt file from the tmp-mount/ folder as you wish

7. Unmount the boot partition
```shell
$ sudo umount tmp-mount
```

8. Remove the loop device partitions
```shell
$ sudo losetup -D
```

## Modify kernel-module-build example project
This project has been the starting point to build the kernel module: https://github.com/balena-os/kernel-module-build

## Modify the build files
Modifed the Dockerfile, build.sh and run.sh with the relevant parts from [seeed-voicecard repo](https://github.com/respeaker/seeed-voicecard).

Slightly modified [Makefile](./seeed-voicecard/Makefile).
Copy pasted parts of [install.sh](./seeed-voicecard/install.sh) to Dockerfile.

## Current state

Seeing errors
```
12.05.20 13:12:14 (+0300)  main  OS Version is 2.48.0+rev1
12.05.20 13:12:14 (+0300)  main  Loading snd-soc-simple-card first...
12.05.20 13:12:14 (+0300)  main  Loading module from seeed-voicecard_raspberrypi4-64_2.48.0+rev1
12.05.20 13:12:14 (+0300)  main  insmod: ERROR: could not load module seeed-voicecard_raspberrypi4-64_2.48.0+rev1/snd-soc-ac108.ko: No such file or directory
12.05.20 13:12:14 (+0300)  main  insmod: ERROR: could not load module seeed-voicecard_raspberrypi4-64_2.48.0+rev1/snd-soc-seeed-voicecard.ko: No such file or directory
```


Although `lsmod | grep snd` shows:
```
12.05.20 13:12:14 (+0300)  main  snd_soc_ac108          65536  0
12.05.20 13:12:14 (+0300)  main  snd_soc_seeed_voicecard    16384  1 snd_soc_ac108
12.05.20 13:12:14 (+0300)  main  snd_soc_wm8960         49152  0
12.05.20 13:12:14 (+0300)  main  snd_soc_simple_card    16384  0
12.05.20 13:12:14 (+0300)  main  snd_soc_simple_card_utils    16384  2 snd_soc_seeed_voicecard,snd_soc_simple_card
12.05.20 13:12:14 (+0300)  main  snd_soc_bcm2835_i2s    20480  0
12.05.20 13:12:14 (+0300)  main  regmap_mmio            16384  1 snd_soc_bcm2835_i2s
12.05.20 13:12:14 (+0300)  main  snd_bcm2835            28672  0
12.05.20 13:12:14 (+0300)  main  snd_soc_core          217088  7 snd_soc_seeed_voicecard,snd_soc_bcm2835_i2s,vc4,snd_soc_ac108,snd_soc_simple_card_utils,snd_soc_simple_card,snd_soc_wm8960
12.05.20 13:12:14 (+0300)  main  snd_compress           20480  1 snd_soc_core
12.05.20 13:12:14 (+0300)  main  snd_pcm_dmaengine      16384  1 snd_soc_core
12.05.20 13:12:14 (+0300)  main  snd_pcm               126976  6 snd_soc_bcm2835_i2s,vc4,snd_bcm2835,snd_soc_core,snd_soc_wm8960,snd_pcm_dmaengine
12.05.20 13:12:14 (+0300)  main  snd_timer              40960  1 snd_pcm
12.05.20 13:12:14 (+0300)  main  snd                    86016  6 snd_bcm2835,snd_timer,snd_compress,snd_soc_core,snd_pcm,snd_soc_wm8960
```

Test command provided in seeed-voicecard repo does not work
```shell
$ arecord -L
bash: arecord: command not found
```
I couldn't get `seeed-voicecard.service` running
```shell
$ systemctl status seeed-voicecard.service
Unit seeed-voicecard.service could not be found.
$ systemctl enable seeed-voicecard.service
Failed to enable unit: Unit file seeed-voicecard.service does not exist.
```

Furthermore I don't see the codecs copied (`snd-soc-ac108.ko` and `snd-soc-seeed-voicecard.ko`) as part of `install` in [Makefile](./seeed-voicecard/Makefile):
```
$ ls /lib/modules/4.19.75/kernel/sound/soc/codecs/
$ ls /lib/modules/4.19.75/kernel/sound/soc/bcm/
```
