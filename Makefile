# AMD ISP4 Camera Driver
KVER ?= $(shell uname -r)
TARGET_DIR := linux-$(KVER)

.PHONY: all install clean setup

all: setup
	$(MAKE) -C $(TARGET_DIR) build

install: all
	sudo install -Dm644 $(TARGET_DIR)/amd_capture.ko /lib/modules/$(KVER)/extra/amd_capture.ko
	sudo depmod -a $(KVER)
	-sudo modprobe -r amd_isp4_capture 2>/dev/null
	-sudo modprobe -r amd_capture 2>/dev/null
	sudo modprobe amd_capture
	echo "amd_capture" | sudo tee /etc/modules-load.d/amd-camera.conf >/dev/null

clean:
	-$(MAKE) -C $(TARGET_DIR) clean

setup:
	@./setup $(KVER)
