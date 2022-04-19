
/*************************************************************
时间设置模块，通过ctrl和add按键来设置时间
具体设置方法如下：
按下CTRL 键后进入设置状态，从低位到高位依次设置，按ADD键+1
再次按下CTRL键后进如下一位
完成所有位设置后再次按下CTRL重新进行计时
*************************************************************/
module time_set
(
    input clk,
    input rst_n,
    input key_ctrl_flag,
    input key_add_flag,

    output reg [3:0] set_data,
    output reg [2:0] set_pos,
    output reg       set_flag,
    output reg        work_en
);

parameter IDLE         = 7'b0000001,
          S_L_SET      = 7'b0000010,    //秒钟低位设置
          S_H_SET      = 7'b0000100,    //秒钟高位设置
          M_L_SET      = 7'b0001000,    //分钟低位设置
          M_H_SET      = 7'b0010000,    //分钟高位设置
          H_L_SET      = 7'b0100000,    //时钟低位设置
          H_H_SET      = 7'b1000000;    //时钟高位设置

reg [6:0] state;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else if (key_ctrl_flag == 1'b1 && state == H_H_SET)
        state <= (state << 1)+ 1'b1;
    else if (key_ctrl_flag == 1'b1)
        state <= state << 1;
    else 
        state <= state;
end

//进入设置模式后将时钟的工作使能信号拉低，设置完成后拉高
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        work_en <= 1'b1;
    else if (state == IDLE && key_ctrl_flag == 1'b1)
        work_en <= 1'b0;
    else if (state == H_H_SET && key_ctrl_flag == 1'b1)
        work_en <= 1'b1;
    else 
        work_en <= work_en;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        set_data <= 4'd0;
    else 
        case(state)
            IDLE :
                set_data <= 4'd0;
            S_L_SET,M_L_SET,H_L_SET:
                if (key_add_flag == 1'b1 && set_data == 4'd9)
                    set_data <= 4'd0;
                else if(key_add_flag == 1'b1)
                    set_data <= set_data + 1'b1;                
                else if (key_ctrl_flag == 1'b1)
                    set_data <= 4'd0;
            S_H_SET,M_H_SET:
                if (key_add_flag == 1'b1 && set_data == 4'd5)
                    set_data <= 4'd0;
                else if(key_add_flag == 1'b1)
                    set_data <= set_data + 1'b1;
                else if (key_ctrl_flag == 1'b1)
                    set_data <= 4'd0;
            H_H_SET :
                if (key_add_flag == 1'b1 && set_data == 4'd2)
                    set_data <= 4'd0;
                else if(key_add_flag == 1'b1)
                    set_data <= set_data + 1'b1;              
                else if (key_ctrl_flag == 1'b1)
                    set_data <= 4'd0;
            default :set_data <= set_data;
        endcase
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        set_flag <= 1'b0;
    else 
        set_flag <= key_add_flag;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        set_pos <= 3'b0;
    else if (state != IDLE && key_ctrl_flag == 1'b1)
        set_pos <= set_pos + 1'b1;
    else if (state != IDLE && key_ctrl_flag == 1'b1 && set_pos == 3'd5)
        set_pos <= 3'b0;
    else 
        set_pos <= set_pos;
end

endmodule