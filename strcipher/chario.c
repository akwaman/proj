#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


// basic character IO to/from stdin/stdout


void main(int argc, char* argv[]) {
  char cin;

  fprintf(stdout, "Enter characters. Type Ctl-C to quit\n");
  
  while (1) {
    cin = getc(stdin);
    if (cin == EOF)
      break;
    else {
      putc(cin, stdout);
      putc('\n', stdout);
    }
  }
}
    
    
  
