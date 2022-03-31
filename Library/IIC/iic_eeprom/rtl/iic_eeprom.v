module iic_eeprom
(
input clk,
input rst_n,
input key_in_wr,
input key_in_rd,

output wire     scl,
inout wire      sda,
output wire     done_flag,
output wire       ds          ,
output wire       oe          ,
output wire       shcp        ,
output wire       stcp
);

parameter CNT_50MS_MAX = 22'd2_499_999;
parameter CNT_1S_MAX = 26'd49_999_999;

// 接收到写入信号后需要生成一个计数器，
// 一个数据的写入需要在1M时钟下29个周期，读出需要47个周期,保证时间有富余，每间隔50个周期（50ms）进行数据更新并且产生Wr_en,rd_en信号
wire rd_flag;
wire wr_flag;
reg  wr_state; // 用来记录wr周期的进行状况
reg  rd_state; // 用来记录rd周期的进行状况
reg  wr_en;
reg  rd_en;
reg  [15:0] addr; // 地址
reg  [7:0]  data; // 数据
reg  [21:0] cnt_50ms;
reg  [25:0] cnt_1s;
reg  [3:0]  cnt_data;//记录发送数据的个数
wire  fifo_wr_req;
wire [7:0] data_to_seg595;
reg  rd_req;
reg  disp_state;
wire [7:0] rd_data_reg;

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      wr_state <= 1'b0;
   else if(wr_flag)
      wr_state <= 1'b1;
   else if(cnt_data == 4'd9 && cnt_50ms == CNT_50MS_MAX)
      wr_state <= 1'b0;
   else 
      wr_state <= wr_state;
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      rd_state <= 1'b0;
   else if(rd_flag)
      rd_state <= 1'b1;
   else if(cnt_data == 4'd9 && cnt_50ms == CNT_50MS_MAX)
      rd_state <= 1'b0;
   else 
      rd_state <= rd_state;
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      cnt_50ms <= 22'd0;
   else if ((wr_state && cnt_50ms == CNT_50MS_MAX) || (rd_state && cnt_50ms == CNT_50MS_MAX))
      cnt_50ms <= 22'd0;
   else if (wr_state || rd_state)
      cnt_50ms <= cnt_50ms + 1'b1; 
   else 
      cnt_50ms <= 22'd0;  
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      cnt_data <= 4'd0;
   else if ((wr_state && cnt_data == 4'd9 && cnt_50ms == CNT_50MS_MAX) ||
            (rd_state && cnt_data == 4'd9 && cnt_50ms == CNT_50MS_MAX) ||
            (disp_state && cnt_data == 4'd9 && cnt_1s == CNT_1S_MAX))
      cnt_data <= 4'd0;
   else if ((wr_state && cnt_50ms == CNT_50MS_MAX)||
            (rd_state && cnt_50ms == CNT_50MS_MAX)||
            (disp_state && cnt_1s == CNT_1S_MAX))
      cnt_data <= cnt_data + 1'b1;
   else if (wr_state || rd_state || disp_state)
      cnt_data <= cnt_data;
   else 
      cnt_data <= 4'd0;
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      wr_en <= 1'b0;
   else if (wr_state && cnt_50ms == 22'd1)
      wr_en <= 1'b1;
   else 
      wr_en <= 1'b0;
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      rd_en <= 1'b0;
   else if (rd_state && cnt_50ms == 22'd1)
      rd_en <= 1'b1;
   else 
      rd_en <= 1'b0;
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      addr <= 16'h0;
   else if (wr_flag || rd_flag)
      addr <= 16'h005a;
   else if (cnt_50ms == CNT_50MS_MAX)
      addr <= addr + 1'b1;
   else 
      addr <= addr;
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      data <= 8'd0;
   else if (wr_flag)
      data <= 8'd107;
   else if (cnt_50ms == CNT_50MS_MAX)
      data <= data + 1'b1;
   else 
      data <= data;
end

// 获取到读数据阶段EEPROM的完成信号作为FIFO的写入信号
assign fifo_wr_req = rd_state && done_flag;

always @(posedge clk ) begin
   if (!rst_n)
      cnt_1s <= 26'd0;
   else if(disp_state && cnt_1s == CNT_1S_MAX)
      cnt_1s <= 26'd0;
   else if(disp_state)
      cnt_1s <= cnt_1s + 1'b1;
   else 
      cnt_1s <= 26'd0;   
end

// 显示状态的拉高
always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      disp_state <= 1'b0;
   else if(rd_state && cnt_data == 4'd9 && cnt_50ms == CNT_50MS_MAX)
      disp_state <= 1'b1;
   else if(cnt_data == 4'd9 && cnt_1s == CNT_1S_MAX)
      disp_state <= 1'b0;
   else 
      disp_state <= disp_state;
end

always@(posedge clk or negedge rst_n) begin
   if (!rst_n)
      rd_req <= 1'b0;
   else if (cnt_1s == 26'd1)
      rd_req <= 1'b1;
   else 
      rd_req <= 1'b0;
end
   

// 由于seg595数值变化太慢人眼感觉不到，需要借助FIFO先进行缓存，缓存后读出
FIFO	FIFO_inst 
(
	.clock ( clk ),
	.data ( rd_data_reg ),
	.rdreq ( rd_req ),
	.wrreq ( fifo_wr_req ),
	.q ( data_to_seg595 )
);



key_filter 
#(
.CNT_MAX(20'd 999999)
)
key_filter_inst_wr
(
   . clk   (clk  )     ,     
   . rst_n (rst_n)     ,
   . key_in    (key_in_wr   ) ,

   . key_flag  ( wr_flag)
);

key_filter 
#(
.CNT_MAX(20'd 999999)
)
key_filter_inst_rd
(
   . clk   (clk  )     ,     
   . rst_n (rst_n)     ,
   . key_in    (key_in_rd   ) ,

   . key_flag  (rd_flag )
);


iic_ctrl  iic_ctrl_inst
(. clk    (clk  ) ,
. rst_n  (rst_n) ,
. wr_en    (wr_en  ) ,
. dev_addr   (7'b1010011) ,
. addr       (addr     ) ,
. data       (data     ) ,
. addr_num   (1'b1 ) ,
. rd_en      ( rd_en) ,

. scl        ( scl    )    ,    
. sda        ( sda       ) ,  
. done_flag  (  done_flag ) ,
. rd_data_reg( rd_data_reg)
);

top_seg595 top_seg595_inst
(
    .data  ({12'b0,data_to_seg595}) ,
    .clk   (clk)  ,
    .rst_n (rst_n),
    .sign  (1'b0) ,    // 1表示负号 ， 0表示正号（不显示）
    .point (6'b111111) , //0 表示点亮，1表示不点亮

    . stcp (stcp) ,
    . shcp (shcp) ,
    . ds   (ds  ) ,  
    . oe   (oe  )
);

endmodule