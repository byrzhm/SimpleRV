#include "ascii.h"

uint8_t ascii_dec_to_uint8(const char *s) {
  uint8_t t = 0;
  for (uint32_t i = 0; i < 3 && s[i] != '\0'; i++) { // tmax = 255
    if (s[i] >= '0' && s[i] <= '9') {
      t = (t << 3) + (t << 1) + (s[i] - '0'); // t = t * 10 + (s[i] - '0')
    }
  }
  return t;
}

uint16_t ascii_dec_to_uint16(const char *s) {
  uint16_t t = 0;
  for (uint32_t i = 0; i < 5 && s[i] != '\0'; i++) { // tmax = 65535
    if (s[i] >= '0' && s[i] <= '9') {
      t = (t << 3) + (t << 1) + (s[i] - '0'); // t = t * 10 + (s[i] - '0')
    }
  }
  return t;
}

uint32_t ascii_dec_to_uint32(const char *s) {
  uint32_t t = 0;
  for (uint32_t i = 0; i < 10 && s[i] != '\0'; i++) { // tmax = 4294967295
    if (s[i] >= '0' && s[i] <= '9') {
      t = (t << 3) + (t << 1) + (s[i] - '0'); // t = t * 10 + (s[i] - '0')
    }
  }
  return t;
}

uint8_t ascii_hex_to_uint8(const char *s) {
  uint8_t t = 0;
  for (uint32_t i = 0; i < 2 && s[i] != '\0'; i++) { // tmax = 255
    if (s[i] >= '0' && s[i] <= '9') {
      t = (t << 4) + (s[i] - '0');
    } else if (s[i] >= 'A' && s[i] <= 'F') {
      t = (t << 4) + (s[i] - 'A' + 10);
    } else if (s[i] >= 'a' && s[i] <= 'f') {
      t = (t << 4) + (s[i] - 'a' + 10);
    }
  }
  return t;
}

uint16_t ascii_hex_to_uint16(const char *s) {
  uint16_t t = 0;
  for (uint32_t i = 0; i < 4 && s[i] != '\0'; i++) { // tmax = 65535
    if (s[i] >= '0' && s[i] <= '9') {
      t = (t << 4) + (s[i] - '0');
    } else if (s[i] >= 'A' && s[i] <= 'F') {
      t = (t << 4) + (s[i] - 'A' + 10);
    } else if (s[i] >= 'a' && s[i] <= 'f') {
      t = (t << 4) + (s[i] - 'a' + 10);
    }
  }
  return t;
}

uint32_t ascii_hex_to_uint32(const char *s) {
  uint32_t t = 0;
  for (uint32_t i = 0; i < 8 && s[i] != '\0'; i++) { // tmax = 4294967295
    if (s[i] >= '0' && s[i] <= '9') {
      t = (t << 4) + (s[i] - '0');
    } else if (s[i] >= 'A' && s[i] <= 'F') {
      t = (t << 4) + (s[i] - 'A' + 10);
    } else if (s[i] >= 'a' && s[i] <= 'f') {
      t = (t << 4) + (s[i] - 'a' + 10);
    }
  }
  return t;
}

int8_t *uint8_to_ascii_hex(uint8_t x, int8_t *buffer, uint32_t n) {
  uint32_t i = 0;
  uint32_t m = 2;
  for (; i < m && i + 1 < n; i++) {
    int8_t t = (x >> ((m - 1 - i) << 2)) & 0x0f;
    if (t >= 0 && t <= 9) {
      buffer[i] = t + '0';
    }
    if (t >= 0xa && t <= 0xf) {
      buffer[i] = t - 0xa + 'a';
    }
  }
  buffer[i] = '\0';
  return buffer;
}

int8_t *uint16_to_ascii_hex(uint16_t x, int8_t *buffer, uint32_t n) {
  uint32_t i = 0;
  uint32_t m = 4;
  for (; i < m && i + 1 < n; i++) {
    int8_t t = (x >> ((m - 1 - i) << 2)) & 0x0f;
    if (t >= 0 && t <= 9) {
      buffer[i] = t + '0';
    }
    if (t >= 0xa && t <= 0xf) {
      buffer[i] = t - 0xa + 'a';
    }
  }
  buffer[i] = '\0';
  return buffer;
}

int8_t *uint32_to_ascii_hex(uint32_t x, int8_t *buffer, uint32_t n) {
  uint32_t i = 0;
  uint32_t m = 8;
  for (; i < m && i + 1 < n; i++) {
    int8_t t = (x >> ((m - 1 - i) << 2)) & 0x0f;
    if (t >= 0 && t <= 9) {
      buffer[i] = t + '0';
    }
    if (t >= 0xa && t <= 0xf) {
      buffer[i] = t - 0xa + 'a';
    }
  }
  buffer[i] = '\0';
  return buffer;
}
