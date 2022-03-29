module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);

reg [3:0] out_reg;

always @(posedge clk ) begin
    if(!resetn)
        out_reg <= 4'b0;
    else
        out_reg <= {in,out_reg[3:1]};
    
end

assign out = out_reg[0]

endmodule