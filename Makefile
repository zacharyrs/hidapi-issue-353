HIDAPI_DIR ?= ./hidapi

CFLAGS+=-I $(HIDAPI_DIR)/hidapi

ifeq "$(OS)" "Windows_NT"
all: upsc-hiddll
endif
ifeq "$(shell uname -s)" "Linux"
CFLAGS+=-I /usr/include/libusb-1.0
all: upsc-libusb upsc-hidraw
endif

$(HIDAPI_DIR)/linux/hid.o $(HIDAPI_DIR)/libusb/hid.o $(HIDAPI_DIR)/windows/hid.o upsc.o: %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

upsc-hiddll: $(HIDAPI_DIR)/windows/hid.o upsc.o
	$(CC) $(CFLAGS) $(HIDAPI_DIR)/windows/hid.o upsc.o -o upsc-hiddll.exe -lsetupapi 

upsc-hidraw: $(HIDAPI_DIR)/linux/hid.o upsc.o
	$(CC) $(CFLAGS) $(HIDAPI_DIR)/linux/hid.o upsc.o -o upsc-hidraw `pkg-config libudev --libs`

upsc-libusb: $(HIDAPI_DIR)/libusb/hid.o upsc.o
	$(CC) $(CFLAGS) $(HIDAPI_DIR)/libusb/hid.o upsc.o -o upsc-libusb `pkg-config libusb-1.0 --libs` -lpthread

clean:
	rm -f $(HIDAPI_DIR)/windows/hid.o $(HIDAPI_DIR)/linux/hid.o $(HIDAPI_DIR)/linusb/hid.o upsc.o upsc-hidraw upsc-libusb upsc-hiddll.exe




