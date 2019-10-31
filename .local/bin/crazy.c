//build with:
//  clang crazy.c -Ofast -s -fno-ident -march=native -flto -o crazy -DPAGESIZE=$(getconf PAGESIZE)

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define CASE_FLIP(x) ((x) << 5)
#define GREATER_EQUAL(x, p) ((x) >= (p))
#define LESS_EQUAL(x, p) ((x) <= (p))
#define UPPER_CASE(x) (GREATER_EQUAL(x, 'A') & LESS_EQUAL(x, 'Z'))
#define LOWER_CASE(x) (GREATER_EQUAL(x, 'a') & LESS_EQUAL(x, 'z'))
#define TOGGLE_ZERO(t, c) ((t) & (c))

int main(void) {
    //found via testing, 32 pages is the fastest
#ifndef PAGESIZE
    const long sz = sysconf(_SC_PAGESIZE) * 32;
#else
    const long sz = PAGESIZE * 32;
#endif
    uint8_t * const restrict buffer = malloc(sz);

    //rather significant improvement
    madvise(buffer, sz, MADV_SEQUENTIAL);

    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
    //for some reason the already sequential stdin benifits from this
    posix_fadvise(STDIN_FILENO, 0, 0, POSIX_FADV_SEQUENTIAL);

    ssize_t ret;
    //while splice and vmsplice were tested the cost of moving to kernel space and back was not worth it
    while ((ret = read(STDIN_FILENO, buffer, sz)) > 0) {
        //found via testing 4 unrolls is optimal before it seems the instruction cache is full
        for (ssize_t i = 0; i < sz; i+=4) {
            {
                const size_t idx = (i+0);
                const uint8_t c   = buffer[idx];
                const bool t = (idx & 1);

                buffer[idx] += CASE_FLIP(TOGGLE_ZERO(t, UPPER_CASE(c)));
                buffer[idx] -= CASE_FLIP(TOGGLE_ZERO(!t, LOWER_CASE(c)));
            }
            {
                const size_t idx = (i+1);
                const uint8_t c   = buffer[idx];
                const bool t = (idx & 1);

                buffer[idx] += CASE_FLIP(TOGGLE_ZERO(t, UPPER_CASE(c)));
                buffer[idx] -= CASE_FLIP(TOGGLE_ZERO(!t, LOWER_CASE(c)));
            }
            {
                const size_t idx = (i+2);
                const uint8_t c   = buffer[idx];
                const bool t = (idx & 1);

                buffer[idx] += CASE_FLIP(TOGGLE_ZERO(t, UPPER_CASE(c)));
                buffer[idx] -= CASE_FLIP(TOGGLE_ZERO(!t, LOWER_CASE(c)));
            }
            {
                const size_t idx = (i+3);
                const uint8_t c   = buffer[idx];
                const bool t = (idx & 1);

                buffer[idx] += CASE_FLIP(TOGGLE_ZERO(t, UPPER_CASE(c)));
                buffer[idx] -= CASE_FLIP(TOGGLE_ZERO(!t, LOWER_CASE(c)));
            }
        }
        write(STDOUT_FILENO, buffer, ret);
    }
    return 0;
}

