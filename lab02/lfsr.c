#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    uint16_t regValueIndex0 = *reg & 0x01;
    uint16_t regValueIndex2 = (*reg >> 2) & 0x01;
    uint16_t regValueIndex3 = (*reg >> 3) & 0x01;
    uint16_t regValueIndex5 = (*reg >> 5) & 0x01;
    uint16_t value = regValueIndex0 ^ regValueIndex2
                   ^ regValueIndex3 ^ regValueIndex5;
    *reg = (*reg >> 1);
    if(value) {
      *reg = *reg | (1 << 15);
    } else {
      *reg = *reg & ~(1 << 15);
    }
}

