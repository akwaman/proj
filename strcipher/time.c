#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


#define N (1<<4)

void main() {

  /*
The <time.h> header declares the structure tm, which includes at least the following members:

int    tm_sec   seconds [0,61]
int    tm_min   minutes [0,59]
int    tm_hour  hour [0,23]
int    tm_mday  day of month [1,31]
int    tm_mon   month of year [0,11]
int    tm_year  years since 1900
int    tm_wday  day of week [0,6] (Sunday = 0)
int    tm_yday  day of year [0,365]
int    tm_isdst daylight savings flag
  */

  // time() - returns current time of system as a time_t value, number of seconds
  
  time_t current_time;
  char * c_time_string;

  struct timespec ts;    
  const struct timespec ts1 = {0, 500000000};
  //  ts1.tv_sec = 0;          // seconds
  //  ts1.tv_nsec = 500000000; // nanosec - 500M ns = 0.5 s
  
  
  for (int i=0; i<N; i++) {
    current_time = time(NULL);

    if (current_time == ((time_t)-1)) {
      (void) fprintf(stderr, "Failure to obtain the current time.\n");
      exit(EXIT_FAILURE);
    }

    
    // convert to local time format
    c_time_string = ctime(&current_time);
    
    if (c_time_string == NULL) {
      (void) fprintf(stderr, "Failure to convert the current time to string.\n");
      exit(EXIT_FAILURE);
    }

    // print out - note ctime() adds already added a terminating newline char
    (void) printf("Current time is %s", c_time_string);
    (void) printf("  current_time %x\n", current_time);

    nanosleep(&ts1, &ts);
  }
  exit(EXIT_SUCCESS);
}
