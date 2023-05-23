# Source and include
BUILD_DIR=build
SRCS=$(wildcard src/*.c)
OBJS=$(SRCS:%.c=build/%.o)
INC=-I ./inc

# MCU configuration
# Set MCU type, clock frequency and programmer
MCU=atmega644
CLOCK_FREQ=8000000
PROG_STR=atmelice

# Compiler flags
CFLAGS=-std=c11 -Wall -Wextra -Werror -mmcu=$(MCU) -DF_CPU=$(CLOCK_FREQ)
LDFLAGS=-Wl,--section-start=.text=0xE000
OPT_FLAGS=-Os -DNDEBUG

# Compiler and utility tools
OBJCOPY=avr-objcopy
CC=avr-gcc

# Project configuration
PROJ_NAME=hexample-bootloader
PROJ_BLD=$(BUILD_DIR)/$(PROJ_NAME)

# Rules

all: $(PROJ_BLD).elf

$(PROJ_BLD).elf: $(OBJS)
	$(CC) -o $@ $^ $(INC) $(CFLAGS) $(OPT_FLAGS) $(LDFLAGS)
	$(OBJCOPY) -O ihex $@ $(PROJ_BLD).hex
	$(OBJCOPY) -O binary $@ $(PROJ_BLD).bin


build/%.o: %.c
	mkdir -p build/src
	$(CC) -c -o $@ $(INC) $(CFLAGS) $(OPT_FLAGS) $< $(LDFLAGS)

release: OPT_FLAGS=-O2 -DNDEBUG
release: $(PROJ_BLD).elf

flash:
	avrdude -c $(PROG_STR) -p $(MCU) -U flash:w:$(PROJ_BLD).hex:i

flash-debug:
	avrdude -c $(PROG_STR) -p $(MCU) -U flash:w:$(PROJ_BLD).elf:e

clean:
	rm -rf build

.PHONY = clean, release, flash, flash-debug
