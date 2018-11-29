// vlog +define+WIDTH=8 +define+ARCH=0 +define+GRP_WIDTH=4 +define+PIPE=1 divider.sv
//`define ARCH 0
//`define WIDTH 32
//`define GRP_WIDTH 4

// carry-ripple adder
module add_rpl #(WIDTH) 
   (input [WIDTH-1:0]        a,
    input [WIDTH-1:0]        b,
    input                    ci,
    output logic             co,
    output logic [WIDTH-1:0] r
    );

  
   logic [WIDTH:0]         r1;
   
   // zero extended add/sub operation to get carry-out from MSB
   assign r1 = {1'b0, a} + {1'b0, b} + ci;
   assign co = r1[WIDTH];
   assign r = r1[WIDTH-1:0];
endmodule

// adder-subtracter with selectable architecture
module add_sub #(ARCH = 0,      // 0=carry-ripple, 1=carry-select
                 WIDTH,         // restricted to being a multiple of 4 for now
                 GRP_WIDTH = 4) // bits per group in carry-select architecture
   (input [WIDTH-1:0]      a,
    input [WIDTH-1:0]      b,
    input                  ci,
    input                  sub, // compute a-b when sub=1
    output logic           co,
    output logic [WIDTH-1:0] r
    );

   localparam GRPS = WIDTH/GRP_WIDTH; // number of carry-select groups
   
   logic [WIDTH-1:0]       b1;
   logic                   ci1;
   logic [WIDTH:0]         sd0, sd1;
   logic [GRPS-1:0]        co0, co1, cs;
   logic [WIDTH:0]         r0, r1;

   assign b1 = sub ? ~b : b;
   assign ci1 = sub ? ~ci : ci; // carry-in / borrow-in

   genvar g;
   
   generate
      if (ARCH == 0) begin // carry ripple architecture is default
         add_rpl #(WIDTH) as (.a(a), .b(b1), .ci(ci1), .co(co), .r(r));
      end else begin // carry-select
         add_rpl #(GRP_WIDTH) asf (.a(a[GRP_WIDTH-1:0]), 
                                   .b(b[GRP_WIDTH-1:0]), 
                                   .ci(ci1), 
                                   .co(cs[0]), 
                                   .r(r[GRP_WIDTH-1:0]));
         for (g=1; g<GRPS; g++) begin: grp
            add_rpl #(GRP_WIDTH) as0 (.a(a[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g]), 
                                      .b(b[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g]), 
                                      .ci(ci1), 
                                      .co(co0[g]), 
                                      .r(r0[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g]));

            add_rpl #(GRP_WIDTH) as1 (.a(a[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g]), 
                                      .b(b[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g]), 
                                      .ci(~ci1), 
                                      .co(co1[g]), 
                                      .r(r1[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g]));

            // select summation group
            assign r[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g] = 
                       cs[g-1] ? r1[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g] :
                                 r0[GRP_WIDTH*(g+1)-1:GRP_WIDTH*g];
            // select group carry out
            assign cs[g] = cs[g-1] ? co1[g] : co0[g];
            
         end
      end
   endgenerate

endmodule 

// non-restoring array divider
module divider #(ARCH = 0,      // adder architecture: 0=carry-ripple, 1=carry-select
                 WIDTH,         // restricted to multiple of 4 bits for now
                 GRP_WIDTH = 4) // bits per group with carry-select adders
   (input [2*WIDTH-1:0]      dividend,
    input [WIDTH-1:0]        divisor,
    output logic [WIDTH-1:0] quotient,
    output logic [WIDTH-1:0] remainder,
    output logic             error_divide_by_zero,
    output logic             overflow
    );

   logic [WIDTH-1:0] partial_rem [WIDTH+1:1];
   logic [WIDTH-1:0] calc [WIDTH+1:1];

   assign error_divide_by_zero = ~(|divisor);
   
   // first stage
   assign partial_rem[1] = dividend[2*WIDTH-1:WIDTH];
   
   // check signs of divider and dividend
   // subtract if same; add if different

   logic [WIDTH+2:0]  sign_chk;
   assign sign_chk[0] = (partial_rem[1][WIDTH-1] == divisor[WIDTH-1]);

   add_sub #(.ARCH(ARCH), .WIDTH(WIDTH)) as1
     (.a(partial_rem[1]),
      .b(divisor),
      .ci(1'b0),
      .sub(sign_chk[0]),
      .co(),
      .r(calc[1]));
   
   assign overflow = (calc[1][WIDTH-1] == partial_rem[1][WIDTH-1]);

   // all intermediate stages
   genvar i;
   generate
      for (i=2; i<(WIDTH+2); i++) begin: row
         assign partial_rem[i] = {calc[i-1][WIDTH-2:0], dividend[WIDTH-(i-1)]};

         assign sign_chk[i] = (calc[i-1][WIDTH-1] == divisor[WIDTH-1]);
         assign quotient[WIDTH-(i-1)] = sign_chk[i];         

         add_sub #(.ARCH(ARCH), .WIDTH(WIDTH)) as
           (.a(partial_rem[i]),
            .b(divisor),
            .ci(1'b0),
            .sub(sign_chk[i]),
            .co(),
            .r(calc[i]));
      end
   endgenerate
   
   // last stage - adjust remainder sign

   assign sign_chk[WIDTH+2] = (calc[WIDTH+1][WIDTH-1] == divisor[WIDTH-1]);
   
   add_sub #(.ARCH(ARCH), .WIDTH(WIDTH)) as
     (.a(calc[WIDTH+1]),
      .b(divisor),
      .ci(1'b0),
      .sub(sign_chk[WIDTH+2]),
      .co(),
      .r(remainder));

endmodule 

// test harness for adder-subtractor
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

// pipelined non-restoring array divider
module divider_pipe #(ARCH = 0,      // adder architecture: 0=carry-ripple, 1=carry-select
                      WIDTH,         // restricted to multiple of 4 bits for now
                      GRP_WIDTH = 4) // bits per group with carry-select adders
   (input [2*WIDTH-1:0]      dividend,
    input [WIDTH-1:0]        divisor,
    output logic [WIDTH-1:0] quotient,
    output logic [WIDTH-1:0] remainder,
    output logic             error_divide_by_zero,
    output logic             overflow,
    input                    clk
    );

   logic [WIDTH-1:0] partial_rem [WIDTH+1:1];
   logic [WIDTH-1:0] calc [WIDTH+1:1];
   logic [WIDTH-1:0] calc_p [WIDTH+1:1];   

   logic [WIDTH-1:0] divisor_p0;
   always @(posedge clk)
     divisor_p0 <= divisor;

   logic [2*WIDTH-1:0] dividend_p0;
   always @(posedge clk)
     dividend_p0 <= dividend;
   
   always @(posedge clk)
     error_divide_by_zero <= ~(|divisor);
   
   // first stage
   always @(posedge clk)   
     partial_rem[1] <= dividend[2*WIDTH-1:WIDTH];
   
   // check signs of divider and dividend
   // subtract if same; add if different

   logic [WIDTH+2:0]  sign_chk;
   always @(posedge clk)      
     sign_chk[0] <= (dividend[2*WIDTH-1] == divisor[WIDTH-1]);

   add_sub #(.ARCH(ARCH), .WIDTH(WIDTH)) as1
     (.a(partial_rem[1]),
      .b(divisor_p0),
      .ci(1'b0),
      .sub(sign_chk[0]),
      .co(),
      .r(calc[1]));

   always @(posedge clk)
     calc_p[1] <= calc[1];
   
   always @(posedge clk)         
     overflow <= (calc[1][WIDTH-1] == partial_rem[1][WIDTH-1]);

   // all intermediate stages
   genvar i;
   generate
      for (i=2; i<(WIDTH+2); i++) begin: row
         assign partial_rem[i] = {calc_p[i-1][WIDTH-2:0], dividend_p0[WIDTH-(i-1)]};

         always @(posedge clk) begin         
            sign_chk[i] <= (calc[i-1][WIDTH-1] == divisor[WIDTH-1]);
            quotient[WIDTH-(i-1)] <= sign_chk[i];
         end

         add_sub #(.ARCH(ARCH), .WIDTH(WIDTH)) as
           (.a(partial_rem[i]),
            .b(divisor),
            .ci(1'b0),
            .sub(sign_chk[i]),
            .co(),
            .r(calc[i]));

            always @(posedge clk)
              calc_p[i] <= calc[i];
      end
   endgenerate
   
   // last stage - adjust remainder sign

   assign sign_chk[WIDTH+2] = (calc_p[WIDTH+1][WIDTH-1] == divisor_p0[WIDTH-1]);

   logic [WIDTH-1:0] remainder_p;
   
   add_sub #(.ARCH(ARCH), .WIDTH(WIDTH)) as
     (.a(calc[WIDTH+1]),
      .b(divisor),
      .ci(1'b0),
      .sub(sign_chk[WIDTH+2]),
      .co(),
      .r(remainder_p));

   always @(posedge clk)         
     remainder <= remainder_p;
endmodule 

// test harness for divider
module divider_top 
   (input                     clk,
    input [2*`WIDTH-1:0]      dividend,
    input [`WIDTH-1:0]        divisor,
    output logic [`WIDTH-1:0] quotient,
    output logic [`WIDTH-1:0] remainder,
    output logic              error_divide_by_zero,

    output logic              overflow
    );

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

`ifdef PIPE   
   divider_pipe #(.WIDTH(`WIDTH), .ARCH(`ARCH), .GRP_WIDTH(`GRP_WIDTH)) div
             (.dividend               (dividend_reg),
              .divisor                (divisor_reg),
              .quotient               (quotient_reg), 
              .remainder              (remainder_reg),             
              .error_divide_by_zero   (error_divide_by_zero_reg),
              .overflow               (overflow_reg),
              .clk                    (clk)
              );
`else
   divider #(.WIDTH(`WIDTH), .ARCH(`ARCH), .GRP_WIDTH(`GRP_WIDTH)) div
             (.dividend               (dividend_reg),
              .divisor                (divisor_reg),
              .quotient               (quotient_reg), 
              .remainder              (remainder_reg),             
              .error_divide_by_zero   (error_divide_by_zero_reg),
              .overflow               (overflow_reg)
              );
`endif   
endmodule 


