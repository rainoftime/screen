#include <stdio.h>
#include <stdlib.h>

#include <screen.h>

int main (int argc, char *argv[])
{
    int amount;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s [# of iterations]\n", argv[0]);
        return 1;
    }

    amount = atoi(argv[1]);

    SCREEN_START(basic_loop);

    for (int i = 0; i < amount; i++) {
        printf("Running %d.\n", i);
    }

    printf("Done.\n");

    SCREEN_END(basic_loop);

    return 0;
}
