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

On first boot, I see the error `insmod: ERROR: could not insert module seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev/snd-soc-ac108.ko: Unknown symbol in module`.

`dmesg` shows:
```
[   15.460062] snd_soc_ac108: loading out-of-tree module taints kernel.
[   15.467865] snd_soc_ac108: Unknown symbol seeed_voice_card_register_set_clock (err -2)
```
Then after restarting the services, these errors are gone. Now we get the following errors about files existing. Seems like `snd-soc-ac108.ko` is installed fine as there are no `dmesg` errors seen.
```
19.05.20 18:45:46 (+0300)  main  OS Version is 2.48.0+rev1
19.05.20 18:45:46 (+0300)  main  Loading snd-soc-simple-card first...
19.05.20 18:45:46 (+0300)  main  Loading modules from seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev
19.05.20 18:45:46 (+0300)  main  insmod: ERROR: could not insert module seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev/snd-soc-seeed-voicecard.ko: File exists
19.05.20 18:45:46 (+0300)  main  insmod: ERROR: could not insert module seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev/snd-soc-wm8960.ko: File exists
```

`lsmod | grep snd` shows the modules loaded fine:
```
snd_soc_ac108          69632  0
snd_soc_wm8960         49152  0
snd_soc_seeed_voicecard    16384  1 snd_soc_ac108
snd_soc_simple_card    16384  0
snd_soc_simple_card_utils    16384  2 snd_soc_seeed_voicecard,snd_soc_simple_card
snd_soc_bcm2835_i2s    20480  0
regmap_mmio            16384  1 snd_soc_bcm2835_i2s
snd_soc_core          217088  7 snd_soc_seeed_voicecard,snd_soc_bcm2835_i2s,vc4,snd_soc_ac108,snd_soc_simple_card_utils,snd_soc_simple_card,snd_soc_wm8960
snd_compress           20480  1 snd_soc_core
snd_bcm2835            28672  0
snd_pcm_dmaengine      16384  1 snd_soc_core
snd_pcm               126976  6 snd_soc_bcm2835_i2s,vc4,snd_bcm2835,snd_soc_core,snd_soc_wm8960,snd_pcm_dmaengine
snd_timer              40960  1 snd_pcm
snd                    86016  6 snd_bcm2835,snd_timer,snd_compress,snd_soc_core,snd_pcm,snd_soc_wm8960
```

But the test command provided in seeed-voicecard repo does not work. `arecord -l` doesn't list any capturing hardware device.
```shell
$ arecord --list-devices
**** List of CAPTURE Hardware Devices ****
```

So at the end the hardware is still not recognized for some reason.

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
