#include <string.h>
#include <stddef.h>
#include <stdlib.h>

// this is an assembly routine which follows the x64 C-ABI Calling Convention
extern ssize_t io_print_buffer(const char* buffer, size_t buffer_size);

int main(void) {
    return io_print_buffer("Hello\n", strlen("Hello\n"));
}

