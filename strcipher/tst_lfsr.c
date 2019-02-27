#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"



void main(int argc, char* argv[]) {
  if (argc < 2) {
      printf("Usage: tst_lfsr <LFSR wordlength>\n");
      exit(EXIT_FAILURE);
  }
    
  uint8_t N = strtol(argv[1], NULL, 10);
  printf("argument: %d\n", N);

  if (N < 1) {
      printf("Usage: tst_lfsr <LFSR wordlength> | wordlength (%d) < 1\n", N);
      exit(EXIT_FAILURE);
  }

  
  uint32_t lfsr = 1;  // non-zero initial state
  uint32_t ctr = 0;
  uint32_t NN;
  char *LUT;
  
  if (N==32) {
    printf("LFSR32 test\n");  

    for (int k=0; k<100; k++) {
      printf("%08x\n", lfsr);
      
      lfsr = next_lfsr32(lfsr);
    }
  } else if (N==16) {
    NN = 1<<N;
    printf("LFSR16 test\n");

    // test if sequence is maximum length of 2^N -1
    // every entry in Look-Up-Table should be 1 at end of test
    LUT = malloc(NN);
    memset(LUT, 0, NN);

    for (int k=0; k<NN-1; k++) {
      lfsr = next_lfsr16(lfsr);
      LUT[lfsr]++;     

      printf("%04x  %04x  LUT[%d]: %d\n", k, lfsr, lfsr, LUT[lfsr]);      
    }

    // the state=0 is not legal
    for (int k=1; k<NN-1; k++) {
      // printf("k : LUT[k] : %d  %d\n", k, LUT[k]);      
      if (LUT[k] != 1) {
	printf("fails at k: %d\n", k);
	exit(EXIT_FAILURE);
      }
    }
    printf("PASS: LFSR16 all legal states covered once\n");
    exit(EXIT_SUCCESS);  // or EXIT_FAILURE    
  }  else if (N==8) {
    NN = 1<<N;
    printf("LFSR8 test\n");

    // test if sequence is maximum length of 2^N -1
    // every entry in Look-Up-Table should be 1 at end of test
    LUT = malloc(NN);
    memset(LUT, 0, NN);

    for (int k=0; k<NN-1; k++) {
      lfsr = next_lfsr8(lfsr);
      LUT[lfsr]++;     

      printf("%02x  %02x  LUT[%d]: %d\n", k, lfsr, lfsr, LUT[lfsr]);      
    }

    // the state=0 is not legal
    for (int k=1; k<NN-1; k++) {
      // printf("k : LUT[k] : %d  %d\n", k, LUT[k]);      
      if (LUT[k] != 1) {
	printf("fails at k: %d\n", k);
	exit(EXIT_FAILURE);
      }
    }
    printf("PASS: LFSR8 all legal states covered once\n");
    exit(EXIT_SUCCESS);  // or EXIT_FAILURE    
  } else {
    printf("LFSR Wordlength %d not supported\n", N);
    exit(EXIT_FAILURE);
  }
  

}
