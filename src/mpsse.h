

#ifndef MPSSE_H_INCLUDED
#define MPSSE_H_INCLUDED

#include <stdint.h>

#if LIBFTDI1 == 1
#include <libftdi1/ftdi.h>
#else
#include <ftdi.h>
#endif

#define MPSSE_OK		0
#define MPSSE_FAIL		-1

#define MPSSE_MSB		0x00
#define MPSSE_LSB		0x08

#define MPSSE_CHUNK_SIZE	65535
#define MPSSE_SPI_RW_SIZE	(63 * 1024) 
#define MPSSE_SPI_TRANSFER_SIZE	512
#define MPSSE_I2C_TRANSFER_SIZE	64

#define MPSSE_LATENCY_MS	2
#define MPSSE_TIMEOUT_DIVISOR	1000000
#define MPSSE_USB_TIMEOUT	120000
#define MPSSE_SETUP_DELAY	25000

#define MPSSE_BITMODE_RESET	0
#define MPSSE_BITMODE_MPSSE	2

#define MPSSE_CMD_SIZE		3
#define MPSSE_MAX_SETUP_COMMANDS	10
#define MPSSE_SS_TX_COUNT	3

#define MPSSE_LOW		0
#define MPSSE_HIGH		1
#define MPSSE_NUM_GPIOL_PINS	4
#define MPSSE_NUM_GPIO_PINS	12

#define MPSSE_NULL_CONTEXT_ERROR_MSG	"NULL MPSSE context pointer!"

/* FTDI interfaces */
enum mpsse_interface
{
	MPSSE_IFACE_ANY	= INTERFACE_ANY,
	MPSSE_IFACE_A 	= INTERFACE_A,
	MPSSE_IFACE_B	= INTERFACE_B,
	MPSSE_IFACE_C	= INTERFACE_C,
	MPSSE_IFACE_D	= INTERFACE_D
};

/* Common clock rates */
enum mpsse_clock_rates
{
	MPSSE_ONE_HUNDRED_KHZ  = 100000,
	MPSSE_FOUR_HUNDRED_KHZ = 400000,
	MPSSE_ONE_MHZ 	 = 1000000,
	MPSSE_TWO_MHZ		 = 2000000,
	MPSSE_FIVE_MHZ	 = 5000000,
	MPSSE_SIX_MHZ 	 = 6000000,
	MPSSE_TEN_MHZ		 = 10000000,
	MPSSE_TWELVE_MHZ 	 = 12000000,
	MPSSE_FIFTEEN_MHZ      = 15000000,
	MPSSE_THIRTY_MHZ 	 = 30000000,
	MPSSE_SIXTY_MHZ 	 = 60000000
};

/* Supported MPSSE modes */
enum mpsse_modes
{
	MPSSE_SPI0    = 1,
	MPSSE_SPI1    = 2,
	MPSSE_SPI2    = 3,
	MPSSE_SPI3    = 4,
	MPSSE_I2C     = 5,
	MPSSE_GPIO    = 6,
	MPSSE_BITBANG = 7,
};

enum mpsse_pins
{
	MPSSE_SK	= 1,
	MPSSE_DO	= 2,
	MPSSE_DI	= 4,
	MPSSE_CS	= 8 ,
	MPSSE_GPIO0	= 16,
	MPSSE_GPIO1	= 32,
	MPSSE_GPIO2	= 64,
	MPSSE_GPIO3	= 128
};

enum mpsse_gpio_pins
{
	MPSSE_GPIOL0 = 0,
	MPSSE_GPIOL1 = 1,
	MPSSE_GPIOL2 = 2,
	MPSSE_GPIOL3 = 3,
	MPSSE_GPIOH0 = 4,
	MPSSE_GPIOH1 = 5,
	MPSSE_GPIOH2 = 6,
	MPSSE_GPIOH3 = 7,
	MPSSE_GPIOH4 = 8,
	MPSSE_GPIOH5 = 9,
	MPSSE_GPIOH6 = 10,
	MPSSE_GPIOH7 = 11
};

enum mpsse_i2c_ack
{
	MPSSE_ACK  = 0,
	MPSSE_NACK = 1
};

#define MPSSE_DEFAULT_TRIS            (MPSSE_SK | MPSSE_DO | MPSSE_CS | MPSSE_GPIO0 | MPSSE_GPIO1 | MPSSE_GPIO2 | MPSSE_GPIO3)  /* SK/DO/CS and GPIOs are outputs, DI is an input */
#define MPSSE_DEFAULT_PORT            (MPSSE_SK | MPSSE_CS)       				/* SK and CS are high, all others low */

enum mpsse_commands
{
	MPSSE_INVALID_COMMAND		= 0xAB,
	MPSSE_ENABLE_ADAPTIVE_CLOCK   = 0x96,
	MPSSE_DISABLE_ADAPTIVE_CLOCK  = 0x97,
	MPSSE_ENABLE_3_PHASE_CLOCK	= 0x8C,
	MPSSE_DISABLE_3_PHASE_CLOCK	= 0x8D,
	MPSSE_TCK_X5			= 0x8A,
	MPSSE_TCK_D5			= 0x8B,
	MPSSE_CLOCK_N_CYCLES		= 0x8E,
	MPSSE_CLOCK_N8_CYCLES		= 0x8F,
	MPSSE_PULSE_CLOCK_IO_HIGH	= 0x94,
	MPSSE_PULSE_CLOCK_IO_LOW	= 0x95,
	MPSSE_CLOCK_N8_CYCLES_IO_HIGH	= 0x9C,
	MPSSE_CLOCK_N8_CYCLES_IO_LOW	= 0x9D,
	MPSSE_TRISTATE_IO		= 0x9E,
};

enum mpsse_low_bits_status
{
	MPSSE_STARTED,
	MPSSE_STOPPED
};

struct mpsse_vid_pid
{
	int vid;
	int pid;
	char *description;
};

struct mpsse_context
{
	struct ftdi_context ftdi; /* parent class */
	char *description;
	enum mpsse_modes mode;
	enum mpsse_low_bits_status status;
	int flush_after_read;
	int vid;
	int pid;
	int clock;
	int xsize;
	int open;
	int endianess;
	uint8_t tris;
	uint8_t pstart;
	uint8_t pstop;
	uint8_t pidle;
	uint8_t gpioh;
	uint8_t trish;
	uint8_t bitbang;
	uint8_t tx;
	uint8_t rx;
	uint8_t txrx;
	uint8_t tack;
	uint8_t rack;
};


#ifdef __cplusplus
extern "C"
{
#endif


struct mpsse_context *mpsse_open_simple(enum mpsse_modes mode, int freq, int endianess);
struct mpsse_context *mpsse_open(int vid, int pid, enum mpsse_modes mode, int freq, int endianess, int interface, const char *description, const char *serial);
struct mpsse_context *mpsse_open_index(int vid, int pid, enum mpsse_modes mode, int freq, int endianess, int interface, const char *description, const char *serial, int index);
void mpsse_close(struct mpsse_context *mpsse);
const char *mpsse_error_string(struct mpsse_context *mpsse);
int mpsse_set_mode(struct mpsse_context *mpsse, int endianess);
void mpsse_enable_bitmode(struct mpsse_context *mpsse, int tf);
int mpsse_set_clock(struct mpsse_context *mpsse, uint32_t freq);
int mpsse_get_clock(struct mpsse_context *mpsse);
int mpsse_get_vid(struct mpsse_context *mpsse);
int mpsse_get_pid(struct mpsse_context *mpsse);
const char *mpsse_get_description(struct mpsse_context *mpsse);
int mpsse_set_loopback(struct mpsse_context *mpsse, int enable);
void mpsse_set_cs_idle(struct mpsse_context *mpsse, int idle);
int mpsse_start(struct mpsse_context *mpsse);
int mpsse_write(struct mpsse_context *mpsse, const char *data, size_t size);
int mpsse_stop(struct mpsse_context *mpsse);
int mpsse_get_ack(struct mpsse_context *mpsse);
void mpsse_set_ack(struct mpsse_context *mpsse, int ack);
void mpsse_send_acks(struct mpsse_context *mpsse);
void mpsse_send_nacks(struct mpsse_context *mpsse);
void mpsse_flush_after_read(struct mpsse_context *mpsse, int tf);
int mpsse_pin_high(struct mpsse_context *mpsse, int pin);
int mpsse_pin_low(struct mpsse_context *mpsse, int pin);
int mpsse_set_direction(struct mpsse_context *mpsse, uint8_t direction);
int mpsse_write_bits(struct mpsse_context *mpsse, char bits, size_t size);
char mpsse_read_bits(struct mpsse_context *mpsse, size_t size);
int mpsse_write_pins(struct mpsse_context *mpsse, uint8_t data);
int mpsse_read_pins(struct mpsse_context *mpsse);
int mpsse_pin_state(struct mpsse_context *mpsse, int pin, int state);
int mpsse_tristate(struct mpsse_context *mpsse);
char mpsse_version(void);

#ifdef SWIGPYTHON
typedef struct swig_string_data
{
        int size;
        char *data;
} swig_string_data;

swig_string_data mpsse_read(struct mpsse_context *mpsse, size_t size);
swig_string_data mpsse_transfer(struct mpsse_context *mpsse, const char *data, size_t size);
#else
char *mpsse_read(struct mpsse_context *mpsse, size_t size);
char *mpsse_transfer(struct mpsse_context *mpsse, const char *data, size_t size);

extern unsigned char mpsse_fast_rw_buf[MPSSE_SPI_RW_SIZE + MPSSE_CMD_SIZE];
int mpsse_fast_write(struct mpsse_context *mpsse, const char *data, size_t size);
int mpsse_fast_read(struct mpsse_context *mpsse, char *data, size_t size);
int mpsse_fast_transfer(struct mpsse_context *mpsse, const char *wdata, char *rdata, size_t size);
#endif


#ifdef __cplusplus
}
#endif


#endif // MPSSE_H_INCLUDED
