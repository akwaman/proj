// Single port memory

module mem #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 13   // 8k words -> 32kB  
)(
    input 		 clk,
    input [AWIDTH-1:0] 	 addr,
    input [DWIDTH-1:0] 	 wdata,
    output [DWIDTH-1:0]  rdata,
    input 		 wen
);
    localparam WORDS=2**AWIDTH;
    localparam AW=$clog2(WORDS);  // this seems to work
   
    logic [DWIDTH-1:0] ram [0:WORDS-1];

    always @ (posedge clk) begin
        if (wen) 
            ram[addr] <= wdata;
    end

    assign rdata = ram[addr];
endmodule
