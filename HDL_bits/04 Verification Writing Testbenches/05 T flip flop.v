module top_module ();

reg t;
reg clk;
reg reset;

wire q;

initial begin
    clk = 1'b0;
    reset <= 1'b1;
    t <= 1'b0;
    #20
    reset <= 1'b0;
    #20
    t <= 1'b1;
    #20
    t <= 1'b0;
end

always #10 clk = ~ clk;

tff  tff_inst(
    .clk     (clk  )   ,
    .reset   (reset)   ,   // active-high synchronous reset
    .t       (t    )   ,       // toggle
    . q      ( q   )   
);

endmodule
