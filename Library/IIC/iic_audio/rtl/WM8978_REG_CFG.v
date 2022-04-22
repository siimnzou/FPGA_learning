module WM8978_REG_CFG
(
    input clk,
    input rst_n,
    input done_flag,

    output reg        cfg_en,
    output wire  [15:0] cfg_data,
    output reg        cfg_done
);

parameter CFG_REG_NUM = 6'd18;

parameter CNT_1MS_MAX = 16'd49_999;

parameter LOUTVOL = 6'd20 ,    //左声道声音设置
          ROUTVOL = 6'd20 ;    //右声道声音设置

parameter SPK_LOUTVOL = 6'd20 ,    //左扬声器声音设置
          SPK_ROUTVOL = 6'd20 ;    //右扬声器声音设置          

reg [15:0]    cnt_1ms  ;  // 上电等待1ms后开始进行配置
reg  [5:0]      cfg_reg_num  ;  // 记录当前配置的寄存器个数
wire [15:0]   cfg_data_reg [CFG_REG_NUM-1:0]; 

// 寄存器配置值输入
assign cfg_data_reg[00] = {7'd0 , 9'b0 };
assign cfg_data_reg[01] = {7'd1 , 9'b1_0010_1111 };
assign cfg_data_reg[02] = {7'd2 , 9'b1_1011_0011 };
assign cfg_data_reg[03] = {7'd4 , 9'b0_0101_0000 };
assign cfg_data_reg[04] = {7'd6 , 9'b0_0000_0001 };
assign cfg_data_reg[05] = {7'd10, 9'b0_0000_1000 };
assign cfg_data_reg[06] = {7'd14, 9'b1_0000_1000 };
assign cfg_data_reg[07] = {7'd43, 9'b0_0001_0000 };
assign cfg_data_reg[08] = {7'd47, 9'b0_0111_0000 };
assign cfg_data_reg[09] = {7'd48, 9'b0_0111_0000 };
assign cfg_data_reg[10] = {7'd49, 9'b0_0000_0110 };
assign cfg_data_reg[11] = {7'd50, 9'b0_0000_0001 };
assign cfg_data_reg[12] = {7'd51, 9'b0_0000_0001 };
assign cfg_data_reg[13] = {7'd52, 3'b110 , LOUTVOL };
assign cfg_data_reg[14] = {7'd53, 3'b110 , ROUTVOL };
assign cfg_data_reg[15] = {7'd54, 3'b110 , SPK_LOUTVOL };
assign cfg_data_reg[16] = {7'd55, 3'b110 , SPK_ROUTVOL }; 
assign cfg_data_reg[17] = {7'd3 , 9'b0_0110_1111 };


always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        cnt_1ms <= 16'd0;
    else if (cnt_1ms == CNT_1MS_MAX)
        cnt_1ms <= CNT_1MS_MAX;
    else 
        cnt_1ms <= cnt_1ms + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cfg_en <= 1'b0;
    else if (cnt_1ms == CNT_1MS_MAX - 1)
        cfg_en <= 1'b1;
    else if (done_flag && cfg_reg_num < CFG_REG_NUM - 1)
        cfg_en <= 1'b1;
    else 
        cfg_en <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cfg_reg_num <= 6'd0;
    else if (done_flag)
        cfg_reg_num <= cfg_reg_num + 1'b1;
    else 
        cfg_reg_num <= cfg_reg_num;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        cfg_done <= 1'b0;
    else if (cfg_reg_num == CFG_REG_NUM - 1 && done_flag)
        cfg_done <= 1'b1;
end

assign cfg_data = cfg_data_reg[cfg_reg_num];

endmodule