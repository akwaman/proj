
comp: led.c
	avr-gcc -g -Os -mmcu=atmega32 -c led.c

elf: led.o
	avr-gcc -g -mmcu=atmega32 -o led.elf led.o

hex: led.elf
	avr-objcopy -j .text -j .data -O ihex led.elf led.hex

#TODO: download hex file to the device using cable
load:
	avr-dude 
