#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


// read in a binary file and show the bytes

//char *char2str(int c) {
//}


void main(int argc, char* argv[]) {
  char *filename = argv[1];
  FILE *fp = fopen(filename, "rb");
  
  char hexdigits[2];
  int radix = 16;
  unsigned char cin;

  while(1) {
      cin = fgetc(fp);
      if (cin != EOF) {
	itoa(cin, hexdigits, radix);
	puts(hexdigits);
	puts(".");
      } else {
	break;
      }
  }



  fclose(fp);
}
