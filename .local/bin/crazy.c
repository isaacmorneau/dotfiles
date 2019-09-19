//build with:
//  clang cRaZy.c -Ofast -s -fno-ident -march=native -flto -o crazy2 -DPAGESIZE=$(getconf PAGESIZE)

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
    long sz;
#ifndef PAGESIZE
    sz = sysconf(_SC_PAGESIZE);
#else
    sz = PAGESIZE;
#endif
    sz *= 32;//found via testing, 32 pages is the fastest
    uint8_t *buffer = malloc(sz);

    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);

    ssize_t ret;
    while ((ret = read(STDIN_FILENO, buffer, sz)) > 0) {
        for (ssize_t i = 0; i < ret; ++i) {
            const uint8_t c   = buffer[i];
            const bool toggle = (i & 1);

            buffer[i] += (toggle && c >= 'A' && c <= 'Z') * 32;
            buffer[i] -= (!toggle && c >= 'a' && c <= 'z') * 32;
        }
        write(STDOUT_FILENO, buffer, ret);
    }
    return 0;
}
