# avr-harlock-demo

A simple demo app for an AVR ATMega644 MCU, that reserves a small section of program memory to host its SHA1 hash for verifivation purposes.
The bootloader is in a nested project, within the bootloader directory.

# Build

The root Makefile has a make and make flash-complete target that can be used to build a single .hex file 
containing both application and bootloader

```bash
make
make flash-complete
```

To build the bootloader separately

```bash
cd bootloader
make
```

## SHA1
SHA1 library originally from [@gabrielrcouto/avr-sha1](https://github.com/gabrielrcouto/avr-sha1) licensed under the 
MIT open-source license.