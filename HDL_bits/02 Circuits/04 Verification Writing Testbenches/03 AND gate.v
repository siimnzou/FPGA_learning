module top_module();

reg a;
reg b;
wire out;

initial begin
    a <= 1'b0;
    b <= 1'b0;

    #10
    b <= 1'b1;
    #10
    a <= 1'b1; 
    b <= 1'b0;
    #10
    b <= 1'b1;
end



andgate andgate_inst (
    .in({a,b}),
    .out(out)
);

endmodule
