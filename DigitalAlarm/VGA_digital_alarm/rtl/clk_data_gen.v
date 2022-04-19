/*************************************************************
    时钟数据产生模块，用于产生输出的时钟数据
    当外部传入工作使能为高时，进行计数，产生时间信息。
    当工作使能为低时，可以设置当前时钟
    配合外部传输的设置位置和设置数据完成时间计时起点的设置。
*************************************************************/
module clk_data_gen
(
    input           clk,
    input           rst_n,
    input  [3:0]    set_data,   //接收从时钟设置模块传过来的时钟数据
    input  [2:0]    set_pos,    //接收从时钟设置模块传过来的设置位置（时分秒）
    input           set_flag,   //接收从时钟设置模块传过来的设置信号
    input           work_en,    //外部传入工作时钟，高电平才开始时分秒计数
    
    output wire [5:0]  point,   // 输出的小数点信号
    output wire  [19:0] data,   // 输出的时钟数据
    output wire sign            // 输出的符号位
);

parameter CNT_1S_MAX   = 26'd49_999_999,
          CNT_S_MAX    =   6'd59,
          CNT_M_MAX    =   6'd59,
          CNT_H_MAX    =   5'd23;

reg        work_en_reg;
wire       work_en_down_edge;//采集工作使能的下降沿用于每次设置时间的清零
reg [25:0] cnt_1s;    // 确定1s为基本计时单位
reg [5:0]  cnt_s;     // 记录当前的秒数
reg [3:0]  cnt_s_l_reg;     // 寄存设置的秒钟数低位
reg [3:0]  cnt_s_h_reg;     // 寄存设置的秒钟数高位
reg [5:0]  cnt_m;     // 记录当前的分钟数
reg [3:0]  cnt_m_l_reg;     // 寄存设置的分钟数低位
reg [3:0]  cnt_m_h_reg;     // 寄存设置的分钟数高位
reg [4:0]  cnt_h;     // 记录当前的秒钟数
reg [3:0]  cnt_h_l_reg;     // 寄存设置的时钟数低位
reg [3:0]  cnt_h_h_reg;     // 寄存设置的时钟数高位
reg        set_flag_reg;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        work_en_reg <= 1'b1;
    else
        work_en_reg <= work_en;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        set_flag_reg <= 1'b0;
    else
        set_flag_reg <= set_flag;
end

assign work_en_down_edge = (!work_en) && (work_en_reg);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_s_l_reg <= 4'd0;
    else if (work_en_down_edge)
        cnt_s_l_reg <= 4'd0;
    else if (work_en == 1'b0 && set_flag == 1'b1 && set_pos == 3'd0)
        cnt_s_l_reg <= set_data;
    else 
        cnt_s_l_reg <= cnt_s_l_reg;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_s_h_reg <= 3'd0;
    else if (work_en_down_edge)
        cnt_s_h_reg <= 3'd0;
    else if (work_en == 1'b0 &&  set_flag == 1'b1 && set_pos == 3'd1)
        cnt_s_h_reg <= set_data;
    else 
        cnt_s_h_reg <= cnt_s_h_reg;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_m_l_reg <= 4'd0;
    else if (work_en_down_edge)
        cnt_m_l_reg <= 4'd0;
    else if ( work_en == 1'b0 && set_flag == 1'b1 && set_pos == 3'd2)
        cnt_m_l_reg <= set_data;
    else 
        cnt_m_l_reg <= cnt_m_l_reg;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_m_h_reg <= 3'd0;
    else if (work_en_down_edge)
        cnt_m_h_reg <= 3'd0;
    else if ( work_en == 1'b0 &&  set_flag == 1'b1 && set_pos == 3'd3)
        cnt_m_h_reg <= set_data;
    else 
        cnt_m_h_reg <= cnt_m_h_reg;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_h_l_reg <= 4'd0;
    else if (work_en_down_edge)
        cnt_h_l_reg <= 4'd0;
    else if (work_en == 1'b0 &&  set_flag == 1'b1 && set_pos == 3'd4)
        cnt_h_l_reg <= set_data;
    else 
        cnt_h_l_reg <= cnt_h_l_reg;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_h_h_reg <= 2'd0;
    else if (work_en_down_edge)
        cnt_h_h_reg <= 2'd0;
    else if (work_en == 1'b0 &&  set_flag == 1'b1 && set_pos == 3'd5)
        cnt_h_h_reg <= set_data;
    else 
        cnt_h_h_reg <= cnt_h_h_reg;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_1s <= 26'd0;
    else if (cnt_1s == CNT_1S_MAX && work_en == 1'b1) 
        cnt_1s <= 26'd0;
    else if (work_en == 1'b1)
        cnt_1s <= cnt_1s + 1'b1;    
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_s <= 6'd0;
    else if (set_flag_reg == 1'b1 && work_en == 1'b0 ) 
        cnt_s  <= cnt_s_l_reg + 10*cnt_s_h_reg;  
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX && work_en == 1'b1)
        cnt_s <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX && work_en == 1'b1)
        cnt_s <= cnt_s + 1'b1; 
    else 
        cnt_s <= cnt_s;   
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_m <= 6'd0;
    else if (set_flag_reg == 1'b1 && work_en == 1'b0 ) 
        cnt_m  <= cnt_m_l_reg + 10*cnt_m_h_reg;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX  && cnt_m == CNT_M_MAX && work_en == 1'b1)
        cnt_m <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX && work_en == 1'b1)
        cnt_m <= cnt_m + 1'b1; 
    else 
        cnt_m <= cnt_m;   
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_h <= 6'd0;
    else if (set_flag_reg == 1'b1 && work_en == 1'b0 ) 
        cnt_h  <= cnt_h_l_reg + 10*cnt_h_h_reg;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX  && cnt_m == CNT_M_MAX && cnt_h == CNT_H_MAX && work_en == 1'b1)
        cnt_h <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX && cnt_m == CNT_M_MAX && work_en == 1'b1)
        cnt_h <= cnt_h + 1'b1; 
    else 
        cnt_h <= cnt_h;   
end

assign data = cnt_s + cnt_m * 100 + cnt_h *10000;

assign point = 6'b101011;
assign sign  = 1'b0;

endmodule