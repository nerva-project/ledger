#*******************************************************************************
#   Ledger Nano S
#   (c) 2016-2019 Ledger
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

-include Makefile.env
ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif
include $(BOLOS_SDK)/Makefile.defines

ICONNAME = images/icon_nerva.gif

APPVERSION_M=1
APPVERSION_N=7
APPVERSION_P=0

APPVERSION=$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)

DEFINES   += $(MONERO_CONFIG)
DEFINES   += MONERO_VERSION_MAJOR=$(APPVERSION_M) MONERO_VERSION_MINOR=$(APPVERSION_N) MONERO_VERSION_MICRO=$(APPVERSION_P)
DEFINES   += MONERO_VERSION=$(APPVERSION)
DEFINES   += UI_NANO_S

## Debug options
#DEFINES  += DEBUG_HWDEVICE
#DEFINES  += IODUMMYCRYPT
#DEFINES  += IOCRYPT
DEFINES   += IONOCRYPT

ifneq ($(IONOCRYPT),)
	$(info IONOCRYPT enabled)
endif

ifneq ($(IODUMMYCRYPT),)
	$(info IODUMMYCRYPT enabled)
endif

all: default

ifneq ($(NO_CONSENT),)
DEFINES   += NO_CONSENT
endif

DEFINES   += OS_IO_SEPROXYHAL
DEFINES   += HAVE_BAGL HAVE_SPRINTF
DEFINES   += HAVE_IO_USB HAVE_L4_USBLIB IO_USB_MAX_ENDPOINTS=4 IO_HID_EP_LENGTH=64 HAVE_USB_APDU
DEFINES   += CUSTOM_IO_APDU_BUFFER_SIZE=\(255+5+64\)
DEFINES   += HAVE_LEGACY_PID

DEFINES   += USB_SEGMENT_SIZE=64
DEFINES   += U2F_PROXY_MAGIC=\"MOON\"
DEFINES   += HAVE_IO_U2F HAVE_U2F

DEFINES   += UNUSED\(x\)=\(void\)x
DEFINES   += APPVERSION=\"$(APPVERSION)\"

DEFINES	  += IO_SEPROXYHAL_BUFFER_SIZE_B=128

DEBUG = 0
ifneq ($(DEBUG),0)

	ifeq ($(TARGET_NAME),TARGET_NANOX)
		DEFINES   += HAVE_PRINTF PRINTF=mcu_usb_printf
	else
		DEFINES   += HAVE_PRINTF PRINTF=screen_printf
	endif
	DEFINES += PLINE="PRINTF(\"FILE:%s..LINE:%d\n\",__FILE__,__LINE__)"

else

	DEFINES   += PRINTF\(...\)=
	DEFINES   += PLINE\(...\)=

endif

CC        := $(CLANGPATH)clang
AS        := $(GCCPATH)arm-none-eabi-gcc
LD        := $(GCCPATH)arm-none-eabi-gcc

CFLAGS    += -O3 -Os -Wno-implicit-fallthrough -Wno-missing-declarations
LDFLAGS   += -O3 -Os
LDLIBS    += -lm -lgcc -lc

include $(BOLOS_SDK)/Makefile.glyphs

APP_SOURCE_PATH  += src
SDK_SOURCE_PATH  += lib_stusb lib_stusb_impl lib_u2f

include $(BOLOS_SDK)/Makefile.rules
dep/%.d: %.c Makefile
