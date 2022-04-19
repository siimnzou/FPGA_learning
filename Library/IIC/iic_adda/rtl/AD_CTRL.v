module AD_CTRL
(
    input clk,
    input rst_n,
    input done_flag,
    input [7:0] rd_data_reg,

    output reg [15:0] addr,
    output reg rd_en,
    output wire [19:0] data
);

// 定义读取单个数据之间的等待时间
parameter CNT_MAX  = 21'd1_999_999;
// 定义AD芯片的控制字
parameter CTRL_BYTE = 8'b0100_0000;

parameter IDLE = 1'b1,
          READING = 1'b0;

reg state;
reg [20:0] cnt_wait;   // 创建一个计数器来控制读取信号的时间 100ms读取一次
reg [31:0] seg_data_reg;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        state <= IDLE ;
    else 
        case(state)
            IDLE :
                if (cnt_wait == CNT_MAX)
                    state <= READING;
                else
                    state <= IDLE;
            READING:
                if (done_flag)
                    state <= IDLE ;
                else 
                    state <= READING;
            default:state <= IDLE;
        endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        rd_en <= 1'b0;
    else if (cnt_wait == CNT_MAX)
        rd_en <= 1'b1;
    else 
        rd_en <= 1'b0;
end

always @(posedge clk or negedge rst_n ) begin
    if (~rst_n)
        addr <= 16'b0;
    else 
        addr <= CTRL_BYTE ;
end


always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        cnt_wait <= 21'd0;
    else if (state == IDLE && cnt_wait == CNT_MAX)
        cnt_wait <= 21'd0;
    else if (state == IDLE)
        cnt_wait <= cnt_wait + 1'b1;
    else 
        cnt_wait <= 21'd0;     
end

always @(posedge clk or negedge rst_n ) begin
    if (~rst_n)
        seg_data_reg <= 32'b0;
    else if (done_flag)
        seg_data_reg <= (rd_data_reg * 3300) >> 4'd8;
    else 
        seg_data_reg <= seg_data_reg;
end

assign data = seg_data_reg[19:0];


endmodule
