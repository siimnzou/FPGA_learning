module top_module();

reg a;
reg b;
wire out;

initial begin
    a <= 1'b0;
    b <= 1'b0;
    #5
    b <= 1'b1;
    #5
    a <= 1'b1; 
    #5
    b <= 1'b0;
    #5
    b <= 1'b1;
end



andgate (
    .in({a,b}),
    .out(out)
);

endmodule
