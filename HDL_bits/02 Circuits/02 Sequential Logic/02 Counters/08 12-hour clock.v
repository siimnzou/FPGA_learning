// 需要采用2位BCD码计数器来编写
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

wire [2:0] enable;
wire [1:0] reset_reg;
wire reset_full;

assign enable[0] = (ena)? 1'b1 : 1'b0;    // 控制秒钟信号
assign enable[1] = (ena && ss == 8'h59) ? 1'b1 : 1'b0;  // 控制分钟信号
assign enable[2] = (ena && mm == 8'h59 && ss == 8'h59)? 1'b1 : 1'b0; // 控制时钟信号

assign reset_reg[0] = (reset || ss == 8'h59) ? 1'b1 : 1'b0;  // 控制秒钟信号复位
assign reset_reg[1] = (reset || (mm == 8'h59 && ss == 8'h59)) ? 1'b1 : 1'b0; // 控制分钟信号复位
assign reset_full = (mm == 8'h59 && ss == 8'h59 && hh == 8'h12)? 1'b1 : 1'b0; // 控制时钟信号复位计满复位

two_bit_BCD_counter1 ss_inst
(
    .clk(clk), 
    .reset(reset_reg[0]), 
    .enable(enable[0]) ,
    .q(ss)
);

two_bit_BCD_counter1 hh_inst 
(   .clk(clk),
    .reset(reset_reg[1]),
    .enable( enable[1]) ,
    .q(mm)
);

two_bit_BCD_counter2 mm_inst 
(   .clk(clk), 
    .enable(enable[2]),
    .reset(reset), 
    .reset_full(reset_full), 
    .q(hh)
);

always @(posedge clk ) begin
    if (reset)
        pm <= 1'b0;
    else if (pm == 1'b0 && mm == 8'h59 && ss == 8'h59 && hh == 8'h11)
        pm <= 1'b1;
    else if (pm == 1'b1 && mm == 8'h59 && ss == 8'h59 && hh == 8'h11)
        pm <= 1'b0;
    else 
        pm <= pm;
end

endmodule

module two_bit_BCD_counter1 (
    input clk,
    input reset,   // Synchronous active-high reset
    input enable, // 需要创建一个使能信号来控制该计数器是否工作
    output [8:0] q);

wire ena;  // 内部用于进位的使能信号
assign ena = (q[3:0] == 4'h9) ? 1'b1 : 1'b0 ;

always @(posedge clk ) begin
    if (reset)
        q <= 8'b0;
    else if (enable == 1'b1 && q == 8'h99)
        q <= 8'h0;
    else if (enable == 1'b1 && ena == 1'b1)
        begin
            q[3:0] <= 4'h0;
            q[7:4] <= q[7:4] + 1'b1;
        end 
    else if(enable == 1'b1 )
        q[3:0] <= q[3:0] + 1'b1;
    else 
        q <= q;
end
endmodule
// 用于 hh 信号的计数器
module two_bit_BCD_counter2 (
    input clk,
    input reset,   // 全局复位信号时需要复位到12
    input reset_full,   // 计数器计满后需要复位到 01
    input enable,   // 需要创建一个使能信号来控制该计数器是否工作
    output [8:0] q);

wire ena;
assign ena = (q[3:0] == 4'h9) ? 1'b1 : 1'b0 ;  // 内部用于进位的使能信号

always @(posedge clk ) begin
    if (reset)
        q <= 8'h12;
    else if (enable == 1'b1 && reset_full)
        q <= 8'h01;
    else if (enable == 1'b1 && q == 8'h99 )
        q <= 8'h0;
    else if (enable == 1'b1 && ena == 1'b1)
        begin
            q[3:0] <= 4'h0;
            q[7:4] <= q[7:4] + 1'b1;
        end 
    else if(enable == 1'b1 )
        q[3:0] <= q[3:0] + 1'b1;
    else
        q <= q;
end

endmodule
