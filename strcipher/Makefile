# DBG=-DDEBUG
OPTION=-g ${DBG}

lfsr.o : lfsr.c
	gcc ${OPTION} -c lfsr.c

tst_lfsr: tst_lfsr.c lfsr.o
	gcc ${OPTION} -o tst_lfsr tst_lfsr.c lfsr.o



genrand : genrand.c
	gcc -DDEBUG=1 -g -o genrand genrand.c


clean:
	rm -rf *.o


