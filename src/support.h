#ifndef _SUPPORT_H_
#define _SUPPORT_H_

#include "mpsse.h"

int mpsse_raw_write(struct mpsse_context *mpsse, unsigned char *buf, int size);
int mpsse_raw_read(struct mpsse_context *mpsse, unsigned char *buf, int size);
void mpsse_set_timeouts(struct mpsse_context *mpsse, int timeout);
uint16_t mpsse_freq2div(uint32_t system_clock, uint32_t freq);
uint32_t mpsse_div2freq(uint32_t system_clock, uint16_t div);
unsigned char *mpsse_build_block_buffer(struct mpsse_context *mpsse, uint8_t cmd, const unsigned char *data, size_t size, int *buf_size);
int mpsse_set_bits_high(struct mpsse_context *mpsse, int port);
int mpsse_set_bits_low(struct mpsse_context *mpsse, int port);
int mpsse_gpio_write(struct mpsse_context *mpsse, int pin, int direction);
int mpsse_is_valid_context(struct mpsse_context *mpsse);

#endif
