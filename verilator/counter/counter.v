module counter #(parameter WIDTH = 8)
(
    input             clk,
    input             rst,

    input             cen,  	      	// counter enable
    input             wen,  	      	// write enable
    input [WIDTH-1:0] dat,  	      	// input data
    output logic      [WIDTH-1:0] o_p,  // output value (posedge counter)
    output logic      [WIDTH-1:0] o_n   // output value (negedge counter)
);
    always @ (posedge clk or posedge rst) begin
        if (rst) 
            o_p <= {WIDTH{1'b0}};
        else     
            o_p <= wen ? dat : o_p + {{WIDTH-1{1'b0}}, cen};
    end

    always @ (negedge clk or posedge rst) begin
        if (rst) 
            o_n <= {WIDTH{1'b0}};
        else 
            o_n <= wen ? dat : o_n + {{WIDTH-1{1'b0}}, cen};
    end
endmodule
