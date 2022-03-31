// 其实是一个找规律的题 注意最低位是在最右，最高位在最左。
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 

integer i;
always @(posedge clk ) begin
    if (load)
        q <= data;
    else
        begin
            q[0]   <= q[0];
            q[511] <= q[511] | q[510];
            for (i = 1 ; i < 511 ; i = i + 1) begin
                case (q[i])
                    1'b1 : q[i] <= ~(q[i-1] & q[i+1]);
                    1'b0 : q[i] <= q[i-1] ;
                    default : q[i] <= q[i];
                endcase
            end
        end   
end

endmodule