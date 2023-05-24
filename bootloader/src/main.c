#include <stdint.h>
#include <stdbool.h>
#include <avr/io.h>
#include <util/delay.h>
#include <avr/pgmspace.h>

#include "sha1.h"

#define LED 0

#define METADATA             ((uint8_t *)(0xdfe8))
#define METADATA_SIZE        24

#define OFFSET_TEXT_ADDR     (METADATA + 0)
#define OFFSET_TEXT_SIZE     (METADATA + 2)
#define OFFSET_SHA1HASH      (METADATA + 4)
#define SHA1HASH_SIZE        (20)


void hello_blink(void);
void error_blink(void);
bool is_app_valid(const uint8_t * digest);

int main(void) {
	uint8_t digest[METADATA_SIZE];
	SHA1Context ctx;

	DDRA = (1U << LED);
	PORTA = (0U << LED);

	hello_blink();

	SHA1Reset(&ctx);

	uint16_t text_addr = pgm_read_word(OFFSET_TEXT_ADDR);
	uint16_t text_size = pgm_read_word(OFFSET_TEXT_SIZE);

	size_t i;
	for(i = 0; i < text_size; i++) {
		uint8_t curr_byte = pgm_read_byte((text_addr+i));
		SHA1Input(&ctx, &curr_byte, 1);
	}

	SHA1Result(&ctx, digest);

	if(is_app_valid(digest)) {
		__asm__("jmp 0000");
	}
	error_blink();
}

void hello_blink(void) {
	for(int i = 0; i < 4; i++) {
		PORTA ^= (1U << LED);
		_delay_ms(500);
	}
}

__attribute__((noreturn)) void error_blink(void) {
	for(;;) {
		PORTA ^= (1U << LED);
		_delay_ms(250);
	}
}

bool is_app_valid(const uint8_t * digest) {
	size_t i;
	for(i = 0; i < SHA1HASH_SIZE; i++) {
		uint8_t curr_byte = pgm_read_byte((OFFSET_SHA1HASH+i));
		if(digest[i] != curr_byte) {
			return false;
		}
	}
	return true;
}
