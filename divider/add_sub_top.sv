// synthesis test harness for adder-subtractor

//`define ARCH 0
//`define WIDTH 32
//`define GRP_WIDTH 4

module add_sub_top 
   (input                     clk,
    input [`WIDTH-1:0]        a,
    input [`WIDTH-1:0]        b,
    input                     ci,
    input                     sub, // compute a-b when sub=1
    output logic              co,
    output logic [`WIDTH-1:0] r
    );

   logic [`WIDTH-1:0]         aq,bq,rd;
   logic                     ciq, subq;
   logic                     cod;

   // register all IOs
   always @(posedge clk) begin
      aq <= a;
      bq <= b;
      r <= rd;
      ciq <= ci;
      co <= cod;
      subq <= sub;
   end

   add_sub #(.ARCH(`ARCH), .WIDTH(`WIDTH), .GRP_WIDTH(`GRP_WIDTH)) as
           (.a(aq), .b(bq), .ci(ciq), .sub(subq), .co(cod), .r(rd));
   
endmodule
   