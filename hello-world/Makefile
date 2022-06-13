all: hello-world

%.o: %.asm
	nasm -felf64 $<

hello-world: hello-world.o
	ld -o $@ $<

clean:
	$(RM) -fv *.o

