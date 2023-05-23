#include <avr/io.h>
#include <util/delay.h>

#define LED         0
#define HEADER_SIZE 24

const uint8_t header[HEADER_SIZE] __attribute__((section(".metadata")));

int main(void) {
	DDRA = (1U << LED);
	PORTA = (0U << LED);
	for(;;) {
		PORTA ^= (1U << LED);
		_delay_ms(2000);
	}
}
