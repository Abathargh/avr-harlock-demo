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
LDFLAGS=-Wl,--section-start=.metadata=0xDFE8
OPT_FLAGS=-O2 -g -DDEBUG

# Compiler and utility tools
OBJCOPY=avr-objcopy
CC=avr-gcc

# Project configuration
PROJ_NAME=hexample
PROJ_BLD=$(BUILD_DIR)/$(PROJ_NAME)

# Rules
all: $(PROJ_BLD).elf $(PROJ_BLD)-complete.hex

$(PROJ_BLD).elf: $(OBJS)
	$(CC) -o $@ $^ $(INC) $(CFLAGS) $(OPT_FLAGS) $(MCU_FLAGS) $(LDFLAGS)
	$(OBJCOPY) -O ihex $@ $(PROJ_BLD).hex
	harlock embed.hlk $(PROJ_NAME)
	$(OBJCOPY) -O binary $@ $(PROJ_BLD).bin


build/%.o: %.c
	mkdir -p build/src
	$(CC) -c -o $@ $(INC) $(CFLAGS) $(OPT_FLAGS) $(MCU_FLAGS) $< $(LDFLAGS)

release: OPT_FLAGS=-O2 -DNDEBUG
release: $(PROJ_BLD).elf

flash:
	avrdude -c $(PROG_STR) -p $(MCU) -U flash:w:$(PROJ_BLD).hex:i

flash-complete:
	avrdude -c $(PROG_STR) -p $(MCU) -U flash:w:$(PROJ_BLD)-complete.hex:i

flash-debug:
	avrdude -c $(PROG_STR) -p $(MCU) -U flash:w:$(PROJ_BLD).elf:e

clean:
	rm -rf build

$(PROJ_BLD)-bootloader.elf :
	(cd bootloader; make -f Makefile)
	mv bootloader/build/*.hex bootloader/build/*.elf bootloader/build/*.bin build/

$(PROJ_BLD)-complete.hex : $(PROJ_BLD)-bootloader.elf
	srec_cat $(PROJ_BLD).hex -I $(PROJ_BLD)-bootloader.hex -I -o $(PROJ_BLD)-complete.hex -I
	$(OBJCOPY) -O binary -I ihex $(PROJ_BLD)-complete.hex $(PROJ_BLD)-complete.bin

.PHONY = clean, release, flash, flash-debug, bootloader, clean-bootloader
