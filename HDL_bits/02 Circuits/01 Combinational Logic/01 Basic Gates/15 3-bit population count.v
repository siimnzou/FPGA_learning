module top_module
( 
    input [2:0] in,

    output wire [1:0] out 
);
// case 1 
// assign out = in[0] + in[1] + in[2]; 

// case 2
initial begin
     out = 2'b0;
end
begin : loop
integer i;
for (i = 0 ; i < 3 ; i = i + 1) 
        assign out = out + in[i] ; 
end


endmodule