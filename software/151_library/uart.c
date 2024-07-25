#include "uart.h"

void uwrite_int8(int8_t c) {
  while (!UTRAN_CTRL) // wait for the UART to be ready
    ;
  UTRAN_DATA = c;
}

void uwrite_int8s(const int8_t *s) {
  for (int i = 0; s[i] != '\0'; i++) {
    uwrite_int8(s[i]);
  }
}

int8_t uread_int8(void) {
  while (!URECV_CTRL) // wait for the UART to be ready
    ;
  int8_t ch = URECV_DATA;
  if (ch == '\x0d') { // carriage return
    uwrite_int8s("\r\n");
  } else if (ch == '\x7f') { // delete
    uwrite_int8s("\x08");    // backspace
  } else {
    uwrite_int8(ch); // echo
  }
  return ch;
}

int8_t uread_int8_noecho(void) {
  while (!URECV_CTRL) // wait for the UART to be ready
    ;
  int8_t ch = URECV_DATA;
  return ch;
}
