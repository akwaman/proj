#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>



void main(int argc, char* argv[]) {

  uint32_t sr[2] = {1, 0};
  uint32_t msb;

  //  sr[0] = 1;
  
  for (int j=0; j<2; j++) {
    for (int i=0; i<32; i++) {
      printf("%08x %08x\n", sr[1], sr[0]);

      msb = sr[j]>>31 & 1;
      sr[0] = sr[0] << 1;
      sr[1] = (sr[1] << 1) | msb;      
    }      
  }
}
