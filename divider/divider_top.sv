// synthesis test harness for divider

//`define ARCH 0
//`define WIDTH 32
//`define GRP_WIDTH 4

module divider_top 
   (input                     clk,
    input [2*`WIDTH-1:0]      dividend,
    input [`WIDTH-1:0]        divisor,
    output logic [`WIDTH-1:0] quotient,
    output logic [`WIDTH-1:0] remainder,
    output logic              error_divide_by_zero,
    output logic              overflow
    );

   // set_instance_assignment -name VIRTUAL_PIN ON -to dividend
   // set_instance_assignment -name VIRTUAL_PIN ON -to divisor
   // set_instance_assignment -name VIRTUAL_PIN ON -to quotient
   // set_instance_assignment -name VIRTUAL_PIN ON -to remainder
   // set_instance_assignment -name VIRTUAL_PIN ON -to overflow
   // set_instance_assignment -name VIRTUAL_PIN ON -to error_divide_by_zero

   
   logic [2*`WIDTH-1:0] dividend_reg;
   logic [`WIDTH-1:0]   divisor_reg;
   logic [`WIDTH-1:0]   quotient_reg;
   logic [`WIDTH-1:0]   remainder_reg;
   logic               error_divide_by_zero_reg;
   logic                overflow_reg;             

   // surround divider IOs with registers
   always @(posedge clk) begin
      dividend_reg         <=  dividend;             
      divisor_reg          <=  divisor;     
      quotient             <=  quotient_reg;             
      remainder            <=  remainder_reg;            
      error_divide_by_zero <=  error_divide_by_zero_reg; 
      overflow             <=  overflow_reg;             
   end
   
   divider #(.WIDTH(`WIDTH), .ARCH(`ARCH), .GRP_WIDTH(`GRP_WIDTH)) div
             (.clk                    (clk),
              .dividend               (dividend_reg),
              .divisor                (divisor_reg),
              .quotient               (quotient_reg), 
              .remainder              (remainder_reg),             
              .error_divide_by_zero   (error_divide_by_zero_reg),
              .overflow               (overflow_reg)
              );
              
endmodule 
             
   