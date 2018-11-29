// divider testbench 

`timescale 1ns / 1ns

//`define RANDOM 1

module divider_pipd_tb();
   localparam WIDTH = 5;
   localparam NUM_SIM_CYCLES = 2 ** (2*WIDTH);
   
   logic clk;
   initial begin
      clk <= 1'b0;
      forever #5 clk <= ~clk;
   end

   logic reset;
   initial begin
      reset <= 1'b1;
      #40 reset <= 1'b0;
      $display("%m: reset now deasserted: %t", $time);
   end

   logic [2*WIDTH-1:0] clk_ctr;
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         clk_ctr <= 0;
      end else begin
         clk_ctr <= clk_ctr + 1;

         if (clk_ctr == NUM_SIM_CYCLES) begin
            $display("End of simulation.");
            $finish;
         end         
      end
   end

   logic [2*WIDTH-1:0] dividend = 0;
   logic [WIDTH-1:0]   divisor;
   logic [WIDTH-1:0]   quotient;
   logic [WIDTH-1:0]   remainder;
   logic               error_divide_by_zero;
   logic               overflow;

   always @(posedge clk) begin
      if (reset) begin
         dividend <= 0;
         divisor <= 0;
      end else begin
`ifdef RANDOM
         // random test
         dividend <= $random();
         divisor  <= $random();
`else      
         // exhaustive test
         divisor  <= clk_ctr[WIDTH-1:0];
         dividend <= (divisor == {WIDTH{1'b1}}) ? dividend+1 : dividend;
`endif
      end
   end

   // debug test case
   // assign dividend = 10'b00110_11011;
   // assign divisor = 5'b01100;
 
   string mesg;
   always @(posedge clk) begin
      $sformat(mesg, "clk_ctr %d", clk_ctr);
      $display(mesg);
   end
   
   divider_pipe #(.WIDTH(WIDTH)) dut (.*);

   logic [WIDTH-1:0] quotient_1;
   logic [WIDTH-1:0] remainder_1;
   logic             overflow_1;
   
   divider_10_5 #(.WIDTH(WIDTH)) dut_1 (.*, 
                                        .quotient(quotient_1), 
                                        .remainder(remainder_1), 
                                        .error_divide_by_zero(),
                                        .overflow(overflow_1));

   logic             remainder_error;
   logic             quotient_error;
   logic             overflow_error;

   always @(negedge clk) begin
      remainder_error <= |(remainder ^ remainder_1);
      quotient_error <= |(quotient ^ quotient_1);
      overflow_error <= overflow ^ overflow_1;

      if (remainder_error || quotient_error || overflow_error)
        $display("Mismatch error");
      
   end
   
   always @(posedge clk) begin
      if (error_divide_by_zero)
        $display("Error: divide by zero");
   end
   
   
endmodule
