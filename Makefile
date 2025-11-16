CHAIN=arm-none-eabi
CFLAGS=-std=c99 -Wall
IPATH=-Iinc/
SRC=src/
OBJ=obj/
BIN=bin/

all: app

app: start.o main.o uart.o wdt.o gpio.o
	$(CHAIN)-ld $(OBJ)start.o $(OBJ)main.o $(OBJ)uart.o $(OBJ)wdt.o $(OBJ)gpio.o -T $(SRC)memmap.ld -o $(OBJ)main.elf
	$(CHAIN)-objcopy $(OBJ)main.elf $(BIN)spl.boot -O binary
	cp $(BIN)spl.boot /srv/tftp/appGpio.bin

start.o: $(SRC)start.s
	$(CHAIN)-as $(IPATH) $(SRC)start.s -o $(OBJ)start.o

main.o: $(SRC)main.s
	$(CHAIN)-as $(IPATH) $(SRC)main.s -o $(OBJ)main.o


uart.o: $(SRC)uart.s
	$(CHAIN)-as $(IPATH) $(SRC)uart.s -o $(OBJ)uart.o


wdt.o: $(SRC)wdt.s
	$(CHAIN)-as $(IPATH) $(SRC)wdt.s -o $(OBJ)wdt.o


gpio.o: $(SRC)gpio.s
	$(CHAIN)-as $(IPATH) $(SRC)gpio.s -o $(OBJ)gpio.o
                                                                      


copy:
	cp $(BIN)spl.boot /srv/tftp/appGpio.bin

clean:
	rm -rf $(OBJ)*.o
	rm -rf $(OBJ)*.elf
	rm -rf $(BIN)*.boot

dump:
	$(CHAIN)-objdump -D $(OBJ)main.elf