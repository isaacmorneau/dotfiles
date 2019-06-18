#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
    long sz         = sysconf(_SC_PAGESIZE);
    uint8_t *buffer = (uint8_t *)malloc(sz);

    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);

    ssize_t ret;
    while ((ret = read(STDIN_FILENO, buffer, sz)) > 0) {
        for (ssize_t i = 0; i < ret; ++i) {
            const uint8_t c = buffer[i];
            const bool toggle = (i & 1);

            buffer[i] += (toggle && c >= 65 && c <= 90) * 32;
            buffer[i] -= (!toggle && c >= 97 && c <= 122) * 32;
        }
        write(STDOUT_FILENO, buffer, ret);
    }
    return 0;
}
