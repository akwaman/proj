#ifndef _LFSR_H_
#define _LFSR_H_
#ifdef __cplusplus
extern "c" {
#endif

#include <stdint.h>

  /* Some primitive polynomials:
   * 8,6,5,4,1
   * 12,11,10,4,1
   * 16,15,13,4,1
   * 24,23,22,17,1
   * 32,22,2,1
   * 36,25,1
   * 64,63,61,60,1
   * 72,66,25,19,1
   * 83,82,38,37,1
   * 93,91,1
   * 96,94,49,47,1
   * 112,110,69,67,1
   * 128,126,101,99,1
   */  

  //  typedef struct {
  //    uint8_t taps8[8];
  //  }
  //const 

uint32_t next_lfsr8(uint32_t state);    
uint32_t next_lfsr16(uint32_t state);  
uint32_t next_lfsr32(uint32_t state);


#ifdef __cplusplus
}
#endif
#endif
