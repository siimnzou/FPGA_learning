`timescale  1ns/1ns
module tb_touch_driver();

reg              clk            ;
reg              rst_n          ;
reg   [7:0]     i2c_data_in     ;
reg             i2c_done_flag   ;
wire             wr_en          ;
wire   [6:0]     dev_addr       ;
wire   [15:0]    addr           ;
wire   [7:0]     wr_data        ;
wire             rd_en          ;
wire             addr_num       ;
wire             touch_init     ;
wire             touch_reset    ;
wire    [15:0]   touch_x_loc    ;
wire    [15:0]   touch_y_loc    ;
wire             touch_data_flag;

initial begin
    clk   <= 1'b0;
    rst_n <= 1'b0;
    #200
    rst_n <= 1'b1;
end

reg [5:0] done_flag_wait;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        done_flag_wait <= 6'd0;
    else if (wr_en || rd_en)
        done_flag_wait <= 6'd50;
    else if (done_flag_wait == 6'd0)
        done_flag_wait <= 6'd0;
    else 
        done_flag_wait <= done_flag_wait - 1'b1;
end

always @(posedge clk or rst_n) begin
    if (~rst_n)
        i2c_done_flag <= 1'b0;
    else if (done_flag_wait == 1'b1)
        i2c_done_flag <= 1'b1;
    else 
        i2c_done_flag <= 1'b0;
end

reg [5:0] rd_en_count;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        rd_en_count <= 6'd0;
    else if (rd_en)
        rd_en_count <= rd_en_count + 1'b1;
    else if (touch_data_flag)
        rd_en_count <= 6'd0;
end

reg [8:0] random_loc;
always #20 random_loc = {$random} % 256;


always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        i2c_data_in <= 8'b0;
    else if (rd_en && rd_en_count < 6'd5)
        i2c_data_in <= 8'd0;
    else if (rd_en && rd_en_count == 6'd6)
        i2c_data_in <= 8'b1000_0001;
    else if (rd_en && rd_en_count >= 6'd6)
        i2c_data_in <= random_loc;
end

always #10 clk = ~clk;

touch_driver 
#(
    .DEV_ADDR      ( 7'h14   )    ,   // 器件地址
    .ADDR_NUM      ( 1'b1    )    ,   // 地址位数 1表示16位（与IIC匹配）
    .STATE_REG_ADDR( 16'h814e)    ,   // 状态寄存器地址
    .LOC_START_ADDR( 16'h8150)    ,   // 存放位置信息的起始地址
    .CNT_MS_MAX    ( 16'd499 )    ,
    .IIC_GAP       ( 13'd50  )
)
touch_driver_inst
(
    .clk             (clk          ),
    .rst_n           (rst_n        ),
    .i2c_data_in     (i2c_data_in  ),
    .i2c_done_flag   (i2c_done_flag),

    .wr_en           (wr_en          ),
    .dev_addr        (dev_addr       ),
    .addr            (addr           ),
    .wr_data         (wr_data        ),
    .rd_en           (rd_en          ),
    .addr_num        (addr_num       ),
    .touch_init      (touch_init     ),
    .touch_reset     (touch_reset    ),
    .touch_x_loc     (touch_x_loc    ),
    .touch_y_loc     (touch_y_loc    ),
    .touch_data_flag (touch_data_flag) 
);

endmodule