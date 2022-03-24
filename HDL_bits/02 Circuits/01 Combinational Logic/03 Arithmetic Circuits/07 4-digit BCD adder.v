module top_module( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );

wire [2:0] cout_reg ;

bcd_fadd bcd_fadd_3_0
(
    .a   (a[3:0])  ,
    .b   (b[3:0])  ,
    .cin (cin)  ,
    .cout(cout_reg[0])  ,
    .sum (sum[3:0])
    );

bcd_fadd bcd_fadd_7_4
(
    .a   (a[7:4])  ,
    .b   (b[7:4])  ,
    .cin (cout_reg[0])  ,
    .cout(cout_reg[1])  ,
    .sum (sum[7:4])
    );

bcd_fadd bcd_fadd_11_8
(
    .a   (a[11:8])  ,
    .b   (b[11:8])  ,
    .cin (cout_reg[1])  ,
    .cout(cout_reg[2])  ,
    .sum (sum[11:8])
    );

bcd_fadd bcd_fadd_15_12
(
    .a   (a[15:12])  ,
    .b   (b[15:12])  ,
    .cin (cout_reg[2])  ,
    .cout(cout)  ,
    .sum (sum[15:12])
    );   
endmodule