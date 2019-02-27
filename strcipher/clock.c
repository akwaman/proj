#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


// millisecond resolution timer


#define N (1<<4)

void do_sleep(clock_t wait) {
  clock_t goal;
  goal = wait + clock();
  while (goal > clock());
}

void main() {

  /* time_t is an absolute time, represented as int number of seconds since
            the UNIX epoch (midnight GMT, 1 January 1970)

     clock_t is a relative measure of time, represented as an int number of 
             clock ticks since some point in time (e.g. boot time)
             CLOCKS_PER_SEC clock ticks per sec - usually 1000
	     
     struct tm is a calendar date and time
	 struct tm{
	 int tm_sec;
	 int tm_min;
	 int tm_hour;
	 int tm_mday;
	 int tm_mon;
	 int tm_year;
	 int tm_wday;
	 int tm_yday;
	 int tm_isdst;
	 };
  */
  
  
  clock_t t1, t2;
  t1 = t2 = clock();

  // loop until t2 gets a different value
  while (t1 == t2)
    t2 = clock();

  // print resolution of clock
  printf("CLOCKS_PER_SEC: %d\n", CLOCKS_PER_SEC); // should be  1000 clocks/sec
  printf("clock resolution: %d ms\n",  (t2-t1));


  struct timeval tv1, tv2;

  mingw_gettimeofday(&tv1, NULL);
  printf("sec: %d   usec: %d\n", tv1.tv_sec, tv1.tv_usec);


  // do some delays in a loop

  clock_t start, finish;
  double duration;

  start = clock();
  for (int i=0; i<3; i++) {
    do_sleep((clock_t)1 * CLOCKS_PER_SEC);
    printf("delay %d\n", i);
  }
  finish = clock();
  duration = (double)(finish-start) / CLOCKS_PER_SEC;
  printf("Elapsed time %2.3f seconds\n", duration);

  /*
  struct timeval {
    time_t      tv_sec;     // microseconds 
    suseconds_t tv_usec;    // microseconds 
  };
  */

  mingw_gettimeofday(&tv2, NULL);
  printf("sec: %d   usec: %d\n", tv2.tv_sec, tv2.tv_usec);
  
  printf("Total elapsed time: sec %d  usec: %d\n",
	 tv2.tv_sec-tv1.tv_sec, tv2.tv_usec-tv1.tv_usec);
  
}
