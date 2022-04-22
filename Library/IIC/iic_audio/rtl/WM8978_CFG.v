module WM8978_CFG
(
    input clk,
    input rst_n,

    output wire     scl         , 
    inout  wire     sda         
);

wire done_flag;
wire cfg_flag;
wire cfg_en ;
wire [15:0] cfg_data ;
wire cfg_done;

WM8978_REG_CFG WM8978_REG_CFG_INST
(
    .clk        (clk      ),
    .rst_n      (rst_n    ),
    .done_flag  (done_flag),

    .cfg_en  (cfg_en  )  ,    
    .cfg_data(cfg_data)  ,
    .cfg_done(cfg_done)
);

iic_ctrl IIC_CTRL_INST
(
.clk       (clk  ),     // 系统时钟，此处用的为50MHz
.rst_n     (rst_n),     // 复位信号
.wr_en     (cfg_en), // 写使能信号
.dev_addr  (7'b0011_010), // 输入的器件地址
.addr      (cfg_data[15:8]),    // 写或读地址
.data      (cfg_data[7:0]),    // 输入的数据
.addr_num  (1'b0), // 地址数。1位2位，0为1位
.rd_en     (1'b0), // 读使能信号

.scl         (scl),     //输出到器件的scl线
.sda         (sda),     //输出到器件的sda线
.done_flag   (done_flag),     //完成标志
.rd_data_reg () //读到的数据
);

endmodule