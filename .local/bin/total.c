#define _GNU_SOURCE
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int fast_atoi(const char * restrict p) {
    int x = 0;
    bool neg = false;

    while (*p == ' ') {
        ++p;
    }

    if (*p == '-') {
        neg = true;
        ++p;
    }

    while (*p >= '0' && *p <= '9') {
        x = (x*10) + (*p - '0');
        ++p;
    }

    if (neg) {
        x = -x;
    }

    return x;
}

int main(void) {
    ssize_t total = 0;
    char *line = NULL;
    size_t len = 0;
    ssize_t nread;

    posix_fadvise(STDIN_FILENO, 0, 0, POSIX_FADV_SEQUENTIAL);

    while ((nread = getline(&line, &len, stdin)) != -1) {
        total += fast_atoi(line);
    }
    printf("%ld\n", total);
    free(line);
    exit(EXIT_SUCCESS);
}
