module IIC_ADDA
(
    input clk,
    input rst_n,

    inout  wire sda,
    output wire scl,
    output wire stcp,
    output wire shcp,
    output wire ds,  
    output wire oe   
);

wire [7:0]  rd_data_reg;
wire        done_flag;
wire        rd_en;
wire [15:0] addr;
wire [19:0] data;


parameter DEV_ADDR = 7'b1001000;

iic_ctrl IIC_CTRL_INST
(
.clk        (clk),     // 系统时钟，此处用的为50MHz
.rst_n      (rst_n),     // 复位信号
.wr_en      (), // 写使能信号
.dev_addr   (DEV_ADDR), // 输入的器件地址
.addr       (addr),    // 写或读地址
.data       (),    // 输入的数据
.addr_num   (1'b0), // 地址数。1位2位，0为1位
.rd_en      (rd_en), // 读使能信号

.scl        (scl),     //输出到器件的scl线
.sda        (sda),     //输出到器件的sda线
.done_flag  (done_flag),     //完成标志
.rd_data_reg(rd_data_reg) //读到的数据
);

AD_CTRL AD_CTRL_INST
(
    .clk          (clk) ,
    .rst_n        (rst_n) ,
    .done_flag    (done_flag),
    .rd_data_reg  (rd_data_reg),

    .addr     (addr),
    .rd_en    (rd_en),
    .data     (data)
);

top_seg595 TOP_SEG595_INST
(
   . clk    (clk  )   ,
   . rst_n  (rst_n)   ,
   . data   (data )   ,
   . sign   (1'b0 )   ,
   . point  (6'b110111)   ,

   .stcp    (stcp  )   ,
   .shcp    (shcp  )   ,
   .ds      (ds    )   ,  
   .oe      (oe    )
);

endmodule