module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );

always@(*) begin
integer i;
for(i = 0 ; i < 4 ; i = i + 1)
    out[i] = in[sel*4 + i];
end

endmodule