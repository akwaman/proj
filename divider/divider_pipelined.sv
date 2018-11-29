
// pipelined non-restoring divider

module pipe #(WIDTH = 10)
   (input clk,
    input  [WIDTH-1:0] di,
    output [WIDTH-1:0] do);
   
   always @(posedge clk) do <= di;
endmodule 


module divider_pipelined #(WIDTH = 10)
   (input clk,
    input [2*WIDTH-1:0]      dividend,
    input [WIDTH-1:0]        divisor,
    output logic [WIDTH-1:0] quotient,
    output logic [WIDTH-1:0] remainder,
    output logic             error_divide_by_zero,
    output logic             overflow
    );

   // pipeline stages
   logic [WIDTH-1:0] partial_rem [WIDTH+1:1];
   logic [WIDTH-1:0] calc [WIDTH+1:1];

   assign error_divide_by_zero = ~(|divisor);
   
   // first stage 
   assign divisor_p1 = divisor;
   assign partial_rem[1] = dividend[2*WIDTH-1:WIDTH];
   
   // check signs of diviros and dividendt
   // subtract if same; add if different
   always @(*) begin
      if (partial_rem[1][WIDTH-1] == divisor[WIDTH-1]) begin
         calc[1] = partial_rem[1] - divisor;
      end else begin
         calc[1] = partial_rem[1] + divisor;         
      end
   end
   assign overflow = (calc[1][WIDTH-1] == partial_rem[1][WIDTH-1]);

   // all intermediate stages
   genvar i;
   generate
      for (i=2; i<(WIDTH+2); i++) begin: row
         assign partial_rem[i] = {calc[i-1][WIDTH-2:0], dividend[WIDTH-(i-1)]};
      
         always @(*) begin
            if (calc[i-1][WIDTH-1] == divisor[WIDTH-1]) begin
               quotient[WIDTH-(i-1)] = 1'b1;
               calc[i] = partial_rem[i] - divisor;         
            end else begin
               quotient[WIDTH-(i-1)] = 1'b0;
               calc[i] = partial_rem[i] + divisor;          
            end
         end
      end
   endgenerate
   
   // last stage - adjust remainder sign
   always @(*) begin
      if (calc[WIDTH+1][WIDTH-1] == divisor[WIDTH-1]) begin
         remainder = calc[WIDTH+1] - divisor;         
      end else begin
         remainder = calc[WIDTH+1] + divisor;          
      end
   end
   
endmodule 
