#include <stdio.h>
#include <stdint.h>

#include "Vcounter.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env)
{
    int i;
    int clk;

    // initialize Verilator's state
    Verilated::commandArgs(argc, argv);

    // create DUT instance
    Vcounter* dut = new Vcounter;

    // initialize VCD trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    dut->trace (tfp, 99);
    tfp->open ("counter.vcd");

    // initialize simulation inputs
    dut->clk = 1;
    dut->rst = 1;
    dut->cen = 0;
    dut->wen = 0;
    dut->dat = 0x55;

    // run simulation for 100 clock periods
    for (i=0; i<20; i++) {
        dut->rst = (i < 2);

        for (clk=0; clk<2; clk++) {
          //dump variables into VCD file
          tfp->dump (2*i+clk);

          // toggle clock and evaluate state
          dut->clk = !dut->clk;
          dut->eval ();
        }

        dut->cen = (i > 5);
        dut->wen = (i == 10);

        printf("counter state: %x\n", dut->o_p);
        if (dut->wen == 1) {
            printf("->       load: %x\n", dut->dat);
        }

        if (Verilated::gotFinish()) {
            exit(0);
        }
    }
    tfp->close();
    exit(0);
}
