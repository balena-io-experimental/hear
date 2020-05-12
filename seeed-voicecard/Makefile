#
# Peter Yang <turmary@126.com>
# Copyright (c) 2019 Seeed Studio
#
# MIT License
#

uname_r=$(shell uname -r)

# If KERNELRELEASE is defined, we've been invoked from the
# kernel build system and can use its language
ifneq ($(KERNELRELEASE),)
# $(warning KERNELVERSION=$(KERNELVERSION))

snd-soc-wm8960-objs := wm8960.o
snd-soc-ac108-objs := ac108.o ac101.o
snd-soc-seeed-voicecard-objs := seeed-voicecard.o


obj-m += snd-soc-wm8960.o
obj-m += snd-soc-ac108.o
obj-m += snd-soc-seeed-voicecard.o

ifdef DEBUG
ifneq ($(DEBUG),0)
	ccflags-y += -DDEBUG -DAC101_DEBG
endif
endif

else

KERNEL_TREE_PATH?=/lib/modules/$(uname_r)/build
DEST := /lib/modules/$(uname_r)/kernel

all: snd-soc-ac108.ko snd-soc-wm8960.ko snd-soc-seeed-voicecard.ko install

snd-soc-ac108.ko: ac108.c
	make -C $(KERNEL_TREE_PATH) M=$(PWD) modules

snd-soc-wm8960.ko: wm8960.c
	make -C $(KERNEL_TREE_PATH) M=$(PWD) modules

snd-soc-seeed-voicecard.ko: seeed-voicecard.c
	make -C $(KERNEL_TREE_PATH) M=$(PWD) modules

install:
	sudo cp snd-soc-ac108.ko ${DEST}/sound/soc/codecs/
	sudo cp snd-soc-seeed-voicecard.ko ${DEST}/sound/soc/bcm/
	sudo depmod -a

clean:
	make -C $(KERNEL_TREE_PATH) M=$(PWD) clean

.PHONY: all clean install

endif
