//build with:
//  clang crazy.c -Ofast -s -fno-ident -march=native -flto -o crazy -DPAGESIZE=$(getconf PAGESIZE)

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define CASE_FLIP(x) ((x) << 5)
#define GREATER_EQUAL(x, p) ((x) >= (p))
#define LESS_EQUAL(x, p) ((x) <= (p))
#define UPPER_CASE(x) (GREATER_EQUAL(x, 'A') & LESS_EQUAL(x, 'Z'))
#define LOWER_CASE(x) (GREATER_EQUAL(x, 'a') & LESS_EQUAL(x, 'z'))
#define TOGGLE_ZERO(t, c) ((t) & (c))

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
    //while splice and vmsplice were tested the cost of moving to kernel space and back was not worth it
    while ((ret = read(STDIN_FILENO, buffer, sz)) > 0) {
        for (ssize_t i = 0; i < ret; ++i) {
            const uint8_t c   = buffer[i];
            const bool t = (i & 1);

            buffer[i] += CASE_FLIP(TOGGLE_ZERO(t, UPPER_CASE(c)));
            buffer[i] -= CASE_FLIP(TOGGLE_ZERO(!t, LOWER_CASE(c)));
        }
        write(STDOUT_FILENO, buffer, ret);
    }
    return 0;
}
