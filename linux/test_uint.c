#include <malloc.h>
#include "uint.h"


int main() {
    UInt uint = {
        .data = malloc(1), 
        .size = 1
    };
    uint.data[0] = 255;
    UInt uint2 = {
        .data = malloc(1), 
        .size = 1
    };
    uint2.data[0] = 0;
    UInt uint3 = uint_add(uint, uint2);
    printf("data: %p, size: %p\n", uint3.data, uint3.size);
    free(uint.data);
    free(uint2.data);
    free(uint3.data);
    return 0;
}
