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
Copy pasted parts of [install.sh](./seeed-voicecard/install.sh)

## Current state

Seeing errors
```
08.05.20 15:27:49 (+0300)  main  OS Version is 2.48.0+rev1
08.05.20 15:27:49 (+0300)  main  Loading module from seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev
08.05.20 15:27:49 (+0300)  main  insmod: ERROR: could not insert module seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev/snd-soc-ac108.ko: Unknown symbol in module
08.05.20 15:27:49 (+0300)  main  insmod: ERROR: could not insert module seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev/snd-soc-wm8960.ko: File exists
08.05.20 15:27:49 (+0300)  main  insmod: ERROR: could not insert module seeed-voicecard_raspberrypi4-64_2.48.0+rev1.dev/snd-soc-seeed-voicecard.ko: Unknown symbol in module
08.05.20 15:27:49 (+0300)  main  rmmod: ERROR: Module snd_soc_seeed_voicecard is not currently loaded
```

`dmesg` shows:
```
[  459.210650] snd_soc_ac108: Unknown symbol seeed_voice_card_register_set_clock (err -2)
[  459.239411] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_dai (err -2)
[  459.247681] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_card_name (err -2)
[  459.256454] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_daifmt (err -2)
[  459.264949] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_clk (err -2)
[  459.273355] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_init_dai (err -2)
[  459.281641] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_set_dailink_name (err -2)
[  459.291055] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_clean_reference (err -2)
[  459.299957] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_canonicalize_cpu (err -2)
[  459.308869] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_canonicalize_dailink (err -2)
[  459.356697] snd_soc_ac108: Unknown symbol seeed_voice_card_register_set_clock (err -2)
[  459.388911] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_dai (err -2)
[  459.397311] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_card_name (err -2)
[  459.406362] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_daifmt (err -2)
[  459.415138] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_parse_clk (err -2)
[  459.423513] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_init_dai (err -2)
[  459.431662] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_set_dailink_name (err -2)
[  459.440557] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_clean_reference (err -2)
[  459.449329] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_canonicalize_cpu (err -2)
[  459.458947] snd_soc_seeed_voicecard: Unknown symbol asoc_simple_card_canonicalize_dailink (err -2)
```
