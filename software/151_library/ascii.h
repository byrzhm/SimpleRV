#pragma once

#include "types.h"

uint8_t  ascii_hex_to_uint8 (const char *s);
uint16_t ascii_hex_to_uint16(const char *s);
uint32_t ascii_hex_to_uint32(const char *s);

uint8_t  ascii_dec_to_uint8 (const char *s);
uint16_t ascii_dec_to_uint16(const char *s);
uint32_t ascii_dec_to_uint32(const char *s);

int8_t *uint8_to_ascii_hex (uint8_t  x, int8_t *buffer, uint32_t n);
int8_t *uint16_to_ascii_hex(uint16_t x, int8_t *buffer, uint32_t n);
int8_t *uint32_to_ascii_hex(uint32_t x, int8_t *buffer, uint32_t n);
