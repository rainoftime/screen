#include <screen.h>

SCREEN(pow)
float pow_int(float base, int exponent)
{
    float result = 1.0f;

    for (int i = 0; i < exponent; i++) {
        result *= base;
    }

    return base;
}

