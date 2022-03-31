// 595芯片的驱动模块 将串行数据转变为并行数据
module hc595_ctrl
(
    input       clk,
    input       rst_n,
    input [5:0] sel,
    input [7:0] seg,

    output reg stcp,    // display signal
    output reg shcp,    // work  clk , set at 12.5mHz
    output reg ds,      // input data 
    output reg oe       // work  en
);

reg [1:0]   cnt_clk;
wire [13:0]  ds_data_reg;
reg [3:0]   cnt_bit;


// generate work clk
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt_clk <= 2'b0;
    else 
        cnt_clk <= cnt_clk + 1'b1;  
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shcp <= 1'b0;
    else if (cnt_clk == 2'd0)
        shcp <= 1'b0;
    else if (cnt_clk == 2'd2)
        shcp <= 1'b1;
    else 
        shcp <= shcp;
end
// generate a input data reg 

assign  ds_data_reg = {seg[0],seg[1],seg[2],seg[3],seg[4],seg[5],seg[6],seg[7],sel};

// creat a bit_cnt for ds assign

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_bit <= 4'd0;
    else if (cnt_bit == 4'd13 && cnt_clk == 2'd3)
        cnt_bit <= 4'd0;
    else if (cnt_clk == 2'd3)
        cnt_bit <= cnt_bit + 1'b1;
end

//  ds assign

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ds <= 1'b0;
    else if (cnt_clk == 2'd1)
        ds <= ds_data_reg[cnt_bit];
    else 
        ds <= ds;
end

// pull stcp up after 14 datas shifted.

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        stcp <= 1'b0;
    else if(cnt_bit == 4'd13 && cnt_clk == 2'd3)
        stcp <= 1'b1;
    else
        stcp <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        oe <= 1'b1;
    else
        oe <= 1'b0;
end

endmodule