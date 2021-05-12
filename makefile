CC=gcc
CFLAGS=-m32 -Wall

all:	main.o func.o
	$(CC) $(CFLAGS) main.o func.o -o program
	
main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

func.o:	func.asm
	nasm -f elf func.asm

clean:
	rm -f *.o
