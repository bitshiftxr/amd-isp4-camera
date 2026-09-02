#!/bin/bash
# Download and setup AMD ISP4 driver for current kernel
set -e

KVER="${1:-$(uname -r)}"
TARGET_DIR="linux-$KVER"
MSG_ID="20260506093250.93460-1-Bin.Du@amd.com"
PATCHSET_VER="v11"

if [[ -f "$TARGET_DIR/.patched" ]]; then
  echo "Already set up for $KVER"
  exit 0
fi

echo "Setting up AMD ISP4 driver for kernel $KVER..."

mkdir -p "$TARGET_DIR"
b4 am -l "$MSG_ID"
mkdir -p src/drivers/media/platform/amd/isp4
cd src && git init && git apply --include='drivers/media/platform/amd/isp4/*' ../${PATCHSET_VER}_*.mbx
cd ..
cp src/drivers/media/platform/amd/isp4/*.c src/drivers/media/platform/amd/isp4/*.h "$TARGET_DIR/"
rm -rf src ${PATCHSET_VER}_*.mbx ${PATCHSET_VER}_*.cover

cat >"$TARGET_DIR/Makefile" <<'EOF'
KVER ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVER)/build

obj-m += amd_capture.o
amd_capture-objs := isp4.o isp4_debug.o isp4_interface.o isp4_subdev.o isp4_video.o

build:
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules

clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean 2>/dev/null || rm -f *.o *.ko *.mod* Module.symvers modules.order
EOF

touch "$TARGET_DIR/.patched"
echo "Done. Run 'make install' to build and install."
