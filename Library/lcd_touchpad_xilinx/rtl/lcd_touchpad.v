module lcd_touchpad
(
    input wire           clk           ,
    input wire           rst_n         ,

    inout   wire          touch_init    ,
    output  wire          touch_reset   ,
    output  wire          scl           ,
    inout   wire          sda           ,
    output  wire         hsync       ,
    output  wire         vsync       ,
    output  wire [23:0]  tft_rgb     ,
    output  wire         tft_clk     ,
    output  wire         tft_bl      ,
    output  wire         tft_de      ,
    output  wire         tft_rst      
);

wire            locked_1            ;
wire            locked_2            ;
wire            rst_n_locked        ;
wire            golbal_clk          ;
wire            clk_33m             ;
wire            clk_50m             ;

wire            wr_en               ;
wire   [6:0]    dev_addr            ;
wire   [15:0]   addr                ;
wire   [7:0]    wr_data             ;
wire            rd_en               ;
wire            addr_num            ;

wire   [15:0]   touch_x_loc         ;
wire   [15:0]   touch_y_loc         ;
wire   [15:0]   touch_x_loc_reg     ;
wire   [15:0]   touch_y_loc_reg     ;
wire            touch_data_flag     ;

wire   [7:0]    i2c_data_in         ;
wire            i2c_done_flag       ;    

wire   [9:0]    pix_x               ;
wire   [9:0]    pix_y               ;
wire   [15:0]   tft_rgb_reg         ;
wire   [15:0]   pix_data            ;
wire            fifo_empty          ;
wire            touch_data_req      ;    // 从pix_data_gen模块传来的读信号，当FIFO不为空的时候进行数据读取



assign rst_n_locked = rst_n & locked_1 & locked_2;

assign tft_rgb = {{tft_rgb_reg[15:11],3'b0},{tft_rgb_reg[10:5],2'b0},{tft_rgb_reg[4:0],3'b0}};

   BUFG BUFG_inst (
      .O(golbal_clk), // 1-bit output: Clock output
      .I(clk)  // 1-bit input: Clock input
   );


  clk_wiz_0 clk_33m_gen
   (
    // Clock out ports
    .clk_33m(clk_33m),     // output clk_33m
    // Status and control signals
    .reset(~rst_n), // input reset
    .locked(locked_1),       // output locked
   // Clock in ports
    .clk_in1(golbal_clk));      // input clk_in1

  clk_wiz_1 clk_50m_gen
   (
    // Clock out ports
    .clk_33m(clk_50m),     // output clk_33m
    // Status and control signals
    .reset(~rst_n), // input reset
    .locked(locked_2),       // output locked
   // Clock in ports
    .clk_in1(golbal_clk));      // input clk_in1


iic_ctrl 
#(
    .DIV_FREQ (10'd250)
)
iic_ctrl_inst
(
    .clk      (clk_50m        )   ,    // 系统时钟，此处用的为50MHz
    .rst_n    (rst_n_locked   )   ,    // 复位信号
    .wr_en    (wr_en          )   ,    // 写使能信号
    .dev_addr (dev_addr       )   ,    // 输入的器件地址
    .addr     (addr           )   ,    // 写或读地址
    .data     (wr_data        )   ,    // 输入的数据
    .addr_num (addr_num       )   ,    // 地址数。1位2位，0为1位
    .rd_en    (rd_en          )   ,    // 读使能信号

    .scl         (scl           ),    //输出到器件的scl线
    .sda         (sda           ),    //输出到器件的sda线
    .done_flag   (i2c_done_flag ),    //完成标志
    .rd_data_reg (i2c_data_in   )     //读到的数据
);


touch_driver 
#(
    .DEV_ADDR      ( 7'h14      )    ,   // 器件地址
    .ADDR_NUM      ( 1'b1       )    ,   // 地址位数 1表示16位（与IIC匹配）
    .STATE_REG_ADDR( 16'h814e   )    ,   // 状态寄存器地址
    .LOC_START_ADDR( 16'h8150   )    ,   // 存放位置信息的起始地址
    .CNT_MS_MAX    ( 16'd49_999 )    ,
    .IIC_GAP       ( 13'd5_000  )
)
touch_driver_inst
(
    .clk             (clk_50m      ),
    .rst_n           (rst_n_locked ),
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

clk_50_to_clk_33 clk_50_to_clk_33_inst (
  .wr_clk(clk_50m),              // input wire wr_clk
  .rd_clk(clk_33m),              // input wire rd_clk
  .din({touch_x_loc,touch_y_loc}),  // input wire [31 : 0] din 高16位x,低16位y
  .wr_en(touch_data_flag),                // input wire wr_en
  .rd_en(touch_data_req & ~fifo_empty),                // input wire rd_en
  .dout({touch_x_loc_reg,touch_y_loc_reg}),                  // output wire [31 : 0] dout
  .full(),           // output wire full
  .almost_full(),    // output wire almost_full
  .empty(fifo_empty),  // output wire empty
  .almost_empty()  // output wire almost_empty
);

pix_data_gen pix_data_gen_inst
(
    .clk_33m         (clk_33m             ),
    .rst_n           (rst_n_locked        ), 
    .pix_x           (pix_x               ),
    .pix_y           (pix_y               ),
    .touch_x_loc     (touch_x_loc_reg     ),
    .touch_y_loc     (touch_y_loc_reg     ),
    .touch_req_valid (touch_data_req & ~fifo_empty),

    .touch_data_req  (touch_data_req       ), 
    .pix_data        (pix_data            )
);



tft_ctrl tft_ctrl
(
    .clk_33m         (clk_33m         ) ,
    .sys_rst_n       (rst_n_locked    ) ,
    .pix_data        (pix_data        ) ,
    .pix_x           (pix_x           ) ,
    .pix_y           (pix_y           ) ,
    .hsync           (hsync           ) ,
    .vsync           (vsync           ) ,
    .tft_rgb         (tft_rgb_reg     ) ,
    .tft_clk         (tft_clk         ) ,
    .tft_bl          (tft_bl          ) ,    
    .tft_de          (tft_de          ) ,
    .tft_rst         (tft_rst         )  
);  

endmodule