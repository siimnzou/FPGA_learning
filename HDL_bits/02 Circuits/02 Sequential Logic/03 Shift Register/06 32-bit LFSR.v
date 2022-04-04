//建立一个LFSR 其抽头在32， 22， 2，1， 位

module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 
integer i;

always @(posedge clk ) begin
    if (reset)
        q <= 32'b1;
    else
    begin
        q[31] = q[0];
        for (i = 0 ; i < 31 ; i = i + 1) begin
            if ( i == 21 || i == 1 || i == 0)
                q[i] <= q[i+1] ^ q[0];
            else 
                q[i] <= q[i+1];
        end
    end    
end

endmodule