#include <stdio.h>
#include <unistd.h>

#include <hidapi/hidapi.h>

#define TERM 0x0d // '\r'

int main(int argc, char *argv[]) {
  int res;
  unsigned char buf[9] = {0};
  int i;
  int receiving;
  hid_device *handle;

  // Initialize the hidapi library
  res = hid_init();

  // Open the device using the VID and PID.
  handle = hid_open(0x0665, 0x5161, NULL);

  // Send 'QI\r'.
  buf[1] = 0x51;
  buf[2] = 0x49;
  buf[3] = TERM;
  res = hid_write(handle, buf, 9);
  // res = hid_send_feature_report(handle, buf, 9); // Seems to also work?

  receiving = 1;
  while (receiving) {
    // Reset the buffer (not needed?).
    for (i = 0; i < 9; i++) {
      buf[i] = 0x00;
    }

    // Read an 8-byte response (our total message is chunked).
    res = hid_read(handle, buf, 8);

    // Neither of these work.
    // res = hid_get_feature_report(handle, buf, 9);
    // res = hid_get_input_report(handle, buf, 9);

    // Print out then chunk numbers.
    for (i = 0; i < 8; i++) {
      printf("%d ", buf[i]);
    }
    printf("\n");

    // Print out the chunk as ascii characters.
    for (i = 0; i < 8; i++) {
      // Stop if we hit the terminator
      if (buf[i] == TERM) {
        receiving = 0;
        break;
      }

      printf("%c", buf[i]);
    }
    printf("\n");
  }

  // Close the device.
  hid_close(handle);

  // Finalize the hidapi library.
  res = hid_exit();

  return 0;
}
