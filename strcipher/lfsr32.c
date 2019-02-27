#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

// primitive polynomial: x^32 + x^22 + x^2 + x + 1
// feedback bits : 0x80200002;

uint32_t next_lfsr32(uint32_t state) {
  uint32_t next_state;
  const uint8_t ntaps = 4;
  const uint8_t taps[4] = {1,2,22,32};
  uint32_t lsb = 0;
  
  // xor tap bits and feedback to lsb
  for (int i=0; i<ntaps; i++) {
    lsb = lsb ^ ((state >> taps[i-1]) & 1);
  }
  next_state = (state << 1) | (lsb & 1);
  return state;
}

void main(int argc, char* argv[]) {
  uint32_t lfsr32 = 1;  // non-zero initial state

  for (int k=0; k<100; k++) {
    printf("%08x\n", lfsr32);

    lfsr32 = next_lfsr32(lfsr32);
  }
}
