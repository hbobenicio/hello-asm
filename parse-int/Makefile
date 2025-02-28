all: main

SRCS = $(wildcard *.asm)
OBJS = $(SRCS:.asm=.o)
BIN = main

$(BIN): $(OBJS)
	$(LD) -o $@ $^

%.o: %.asm
	nasm -f elf64 -g $^

.PHONY: run
run: $(BIN)
	./$(BIN)

.PHONY: clean
clean:
	$(RM) *.o

.PHONY: dist-clean
dist-clean: clean
	$(RM) $(BIN)

