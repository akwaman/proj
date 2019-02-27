ifndef _TRIVIUM_H
define _TRIVIUM_H
#ifdef __cplusplus
extern "c" {
#endif


  /*
   * trivium stream Cipher
   *
   * scheidt@gmail.com
   * 2.15.2019
   *
   */


  
  // 80*288-1152 bits shifted
  void init() {
  }

  // store 1 bit per byte - maybe this is fast?

  char[83] sr2;
  char[112] sr3;
  char sr1out, sr2out, sr3out;
  
  char a1, a2, a3;
  char k1, k2, k3;

  char sh93_shift(char a, k) {
    static char[93] sr;    
    sr1out = sr[92];
    for (int i=91; i>0; i--) {
      sr[i] = sr[i-1];
    }
    char fb = sr[90] & sr[91];
    char ff = sr[65] & sr[92];    
    sr1[0] = fb1 ^ k ^ a;
    char k = fb ^ ff;
    return k;
  }

  char sh83_shift(char a, k) {
    static char[83] sr;    
    sr1out = sr[82];
    for (int i=81; i>0; i--) {
      sr[i] = sr[i-1];
    }
    char fb = sr[174] & sr[175];
    char ff = sr[65] & sr[92];    
    sr1[0] = fb1 ^ k ^ a;
    char k = fb ^ ff;
    return k;
  }


  char sh112_shift(char a, k) {
    char[93] sr;    
    sr1out = sr[92];
    for (int i=91; i>0; i--) {
      sr[i] = sr[i-1];
    }
    char fb = sr[90] & sr[91];
    char ff = sr[65] & sr[92];    
    sr1[0] = fb1 ^ k ^ a;
    char k = fb ^ ff;
    return k;
  }
  
  void set_key(char *key) {
  }
  
  void set_iv(char *key) {
  }


  gen_int8_bit   bit#


  gen_int32_byte  byte#


  // data structures - 3 shift registers
  // lengths: 93, 83, 112
  
#ifdef __cplusplus
}
#endif
endif
