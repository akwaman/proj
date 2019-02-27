#include <stdio.h>
#include <stdint.h>
#include "lfsr.h"


//uint32_t next_lfsr8(uint32_t state, uint8_t size) {
uint32_t next_lfsr8(uint32_t state) {
  uint32_t mask_state = ~(0xFFFFFFFF << 8);
  
  uint32_t next_state;
  const uint8_t ntaps = 4;
  const uint8_t taps[4] = {4,5,6,8};
  uint32_t lsb = 0;
  
  // xor tap bits and feedback to lsb
  for (int i=0; i<ntaps; i++) {
    lsb = lsb ^ ((state >> (taps[i]-1)) & 1);
  }
  next_state = (state << 1) | (lsb & 1);

  #ifdef DEBUG
  printf("next_state; %04x\n", next_state);
  #endif
    
  return next_state & mask_state;
}

// primitive polynomial: x^16 + x^15 + x^13 + x^4 + 1
uint32_t next_lfsr16(uint32_t state) {
  uint32_t mask_state = 0x0000FFFF;  
  uint32_t next_state;
  const uint8_t ntaps = 4;
  const uint8_t taps[4] = {4,13,15,16};
  uint32_t lsb = 0;
  
  // xor tap bits and feedback to lsb
  for (int i=0; i<ntaps; i++) {
    lsb = lsb ^ ((state >> (taps[i]-1)) & 1);
  }
  next_state = (state << 1) | (lsb & 1);

  #ifdef DEBUG
  printf("next_state; %04x\n", next_state);
  #endif
    
  return next_state & mask_state;
}

// primitive polynomial: x^32 + x^22 + x^2 + x + 1
uint32_t next_lfsr32(uint32_t state) {
  uint32_t next_state;
  const uint8_t ntaps = 3;
  const uint8_t taps[3] = {2,22,32};
  uint32_t lsb = 0;
  
  // xor tap bits and feedback to lsb
  for (int i=0; i<ntaps; i++) {
    lsb = lsb ^ ((state >> (taps[i]-1)) & 1);
  }
  next_state = (state << 1) | (lsb & 1);

  #ifdef DEBUG
  printf("next_state; %08x\n", next_state);
  #endif
    
  return next_state;
}

/*
// primitive polynomial: x^64 + x^63 + x^61 + x^60 + 1
uint32_t *next_lfsr64(uint32_t *state) {
  uint32_t next_state[2];
  const uint8_t ntaps = 4;
  const uint8_t taps[4] = {1,60,61,64};
  uint32_t lsb = 0;
  
  // xor tap bits and feedback to lsb
  for (int i=0; i<ntaps; i++) {
    lsb = lsb ^ ((state >> (taps[i]-1)) & 1);
  }
  next_state = (state << 1) | (lsb & 1);
  return state;
}

*/
