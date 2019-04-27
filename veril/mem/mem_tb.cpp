#-------------------------------------------------------------------------------
# File: mem_tb.cpp
# Author: Paul Scheidt (scheidt@gmail.com)
# Description:
# Example testbench of a simple memory model.
#-------------------------------------------------------------------------------
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "Vmem.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);

    // init top verilog instance
    Vmem* top = new Vmem;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("mem.vcd");

    // scoreboard
    uint32_t sb[1<<13];

    // initialize random number generator
    srand(1234);
    uint32_t rnd32 = rand();

    // initialize simulation inputs
    top->clk = 1;
    top->wen = 0;
    top->addr = 255;
    top->wdata = 0x55;

    int j=0;
    // run simulation
    for (i=0; i<10; i++) {
      // dump variables into VCD file and toggle clock
      for (clk=0; clk<2; clk++) {
        tfp->dump (2*j+clk);
        top->clk = !top->clk;
        top->eval ();
      }
      j++;
      top->addr = i;
    }

    for (i=0; i<10; i++) {
      top->addr = i;
      //    top->wdata = i;
      top->wdata = rand();
      top->wen = 1;
      // dump variables into VCD file and toggle clock
      for (clk=0; clk<2; clk++) {
        tfp->dump (2*j+clk);
        top->clk = !top->clk;
        top->eval ();
      }
      printf("mem addr: %d  state: %08x\n", top->addr, top->rdata);
      if (top->wen == 1) {
        printf("  mem load addr: %d  data: %08x\n", top->addr, top->wdata);
      }
      j++;
    }

    for (i=0; i<10; i++) {
      top->addr = i;
      top->wen = 0;
      // dump variables into VCD file and toggle clock
      for (clk=0; clk<2; clk++) {
        tfp->dump (2*j+clk);
        top->clk = !top->clk;
        top->eval ();
      }
      printf("mem addr: %d  state: %08x\n", top->addr, top->rdata);
      if (top->wen == 1) {
        printf("  mem load addr: %d  data: %08x\n", top->addr, top->wdata);
      }
      j++;

      if (Verilated::gotFinish())  exit(0);
    }

    tfp->close();
    exit(0);
}
