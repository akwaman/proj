// pipelined non-restoring divider

module divider_10_5 #(WIDTH =5)
   (input clk,
    input [2*WIDTH-1:0]      dividend,
    input [WIDTH-1:0]        divisor,
    output logic [WIDTH-1:0] quotient,
    output logic [WIDTH-1:0] remainder,
    output logic             error_divide_by_zero,
    output logic             overflow    
    );

   localparam PR_MSB = 2*WIDTH-1;

   // pipeline stages
   logic [WIDTH-1:0] partial_rem_p1;
   logic [WIDTH-1:0] partial_rem_p2;
   logic [WIDTH-1:0] partial_rem_p3;
   logic [WIDTH-1:0] partial_rem_p4;
   logic [WIDTH-1:0] partial_rem_p5;
   logic [WIDTH-1:0] partial_rem_p6;      


   logic [WIDTH-1:0] calc_p1;
   logic [WIDTH-1:0] calc_p2;   
   logic [WIDTH-1:0] calc_p3;   
   logic [WIDTH-1:0] calc_p4;   
   logic [WIDTH-1:0] calc_p5;
   logic [WIDTH-1:0] calc_p6;         

   logic [WIDTH-1:0]  divisor_p1;
   logic [WIDTH-1:0]  divisor_p2;
   logic [WIDTH-1:0]  divisor_p3;
   logic [WIDTH-1:0]  divisor_p4;
   logic [WIDTH-1:0]  divisor_p5;   


   assign error_divide_by_zero = ~(|divisor);
   
   int i;
   
   // stage p1
   assign divisor_p1 = divisor;
   assign partial_rem_p1 = dividend[2*WIDTH-1:WIDTH];
   
   // check signs of diviros and dividendt
   // subtract if same; add if different
   always @(*) begin
      if (partial_rem_p1[WIDTH-1] == divisor[WIDTH-1]) begin
         calc_p1 = partial_rem_p1 - divisor;
      end else begin
         calc_p1 = partial_rem_p1 + divisor;         
      end
   end
   assign overflow = (calc_p1[WIDTH-1] == partial_rem_p1[WIDTH-1]);
   
   // stage p2
   assign partial_rem_p2 = {calc_p1[WIDTH-2:0], dividend[WIDTH-1]};   

   always @(*) begin
      if (calc_p1[WIDTH-1] == divisor[WIDTH-1]) begin
         quotient[WIDTH-1] = 1'b1;
         calc_p2 = partial_rem_p2 - divisor;         
      end else begin
         quotient[WIDTH-1] = 1'b0;
         calc_p2 = partial_rem_p2 + divisor;          
      end
   end

   // stage p3
   assign partial_rem_p3 = {calc_p2[WIDTH-2:0], dividend[WIDTH-2]};
      
   always @(*) begin
      if (calc_p2[WIDTH-1] == divisor[WIDTH-1]) begin
         quotient[WIDTH-2] = 1'b1;
         calc_p3 = partial_rem_p3 - divisor;         
      end else begin
         quotient[WIDTH-2] = 1'b0;
         calc_p3 = partial_rem_p3 + divisor;          
      end
   end

   // stage p4
   assign partial_rem_p4 = {calc_p3[WIDTH-2:0], dividend[WIDTH-3]};
      
   always @(*) begin
      if (calc_p3[WIDTH-1] == divisor[WIDTH-1]) begin
         quotient[WIDTH-3] = 1'b1;
         calc_p4 = partial_rem_p4 - divisor;         
      end else begin
         quotient[WIDTH-3] = 1'b0;
         calc_p4 = partial_rem_p4 + divisor;          
      end
   end
   

   // stage p5
   assign partial_rem_p5 = {calc_p4[WIDTH-2:0], dividend[WIDTH-4]};
      
   always @(*) begin
      if (calc_p4[WIDTH-1] == divisor[WIDTH-1]) begin
         quotient[WIDTH-4] = 1'b1;
         calc_p5 = partial_rem_p5 - divisor;         
      end else begin
         quotient[WIDTH-4] = 1'b0;
         calc_p5 = partial_rem_p5 + divisor;          
      end
   end
   
   // stage p5
   assign partial_rem_p6 = {calc_p5[WIDTH-2:0], dividend[WIDTH-5]};
      
   always @(*) begin
      if (calc_p5[WIDTH-1] == divisor[WIDTH-1]) begin
         quotient[WIDTH-5] = 1'b1;
         calc_p6 = partial_rem_p6 - divisor;         
      end else begin
         quotient[WIDTH-5] = 1'b0;
         calc_p6 = partial_rem_p6 + divisor;          
      end
   end

   // last stage - adjust remainder sign
   always @(*) begin
      if (calc_p6[WIDTH-1] == divisor[WIDTH-1]) begin
         remainder = calc_p6 - divisor;         
      end else begin
         remainder = calc_p6 + divisor;          
      end
   end
   
   
endmodule 
