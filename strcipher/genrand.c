#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>


#define N (1<<4)

void main(int argc, char* argv[]) {
  char *randfile = argv[1];
  FILE *fp = fopen(randfile, "wb");
  
  
  uint32_t r;
  srand(time(NULL)); // initialization, called only once

  
  for (int i=0; i<N; i++) {
    r = rand();
    printf("%0x\t", r);

    //fprintf("%0x\t", r);
    fputc(r, fp);

    printf("time: %x\n", time(NULL));    
  }

  fclose(fp);
}
