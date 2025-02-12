all: hello-asm test

main.o: main.asm
	nasm -f elf64 -Wall -g -O0 main.asm

hello-asm: main.o io.o
	ld -g -O0 -o hello-asm io.o main.o

io.o: io.asm linux.asm callconv.asm
	nasm -f elf64 -Wall -g -O0 io.asm

test.o: test.c io.o
	gcc -Wall -Wextra -c test.c

test: test.o
	gcc -o test io.o test.o

.PHONY: clean
clean:
	$(RM) *.o

.PHONY: dist-clean
dist-clean: clean
	$(RM) hello-asm test

debug: hello-asm
	gdb ./hello-asm

run: hello-asm
	./hello-asm

