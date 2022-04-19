module VGA_digital_alarm
(
    input clk,
    input rst_n,
    input key_ctrl_in,
    input key_add_in,

    output wire hsync,
    output wire vsync,
    output wire [15:0] rgb_565
);

wire locked;
wire rst_n_locked;
wire clk_108m;
wire key_ctrl_flag;
wire key_add_flag;
wire [3:0] set_data;
wire [2:0] set_pos;
wire       set_flag;
wire        work_en;
wire [5:0]  point;
wire [19:0] data; 
wire       sign ;        
wire [3:0]  data0;
wire [3:0]  data1;
wire [3:0]  data2;
wire [3:0]  data3;
wire [3:0]  data4;
wire [3:0]  data5; 
wire [11:0] x_loc;
wire [11:0] y_loc;
wire        char_data;
wire [3:0]  char_num;
wire [15:0] pix_data;
wire [9:0]  char_x_loc;
wire [9:0]  char_y_loc;
wire     char_data_req;
wire     pix_data_req;
wire  clk_50m;

assign rst_n_locked = rst_n & locked;

clk_gen	clk_gen_inst (
	.areset ( ~rst_n ),
	.inclk0 ( clk ),
	.c0 ( clk_108m ),
    .c1 ( clk_50m ),
	.locked ( locked )
	);

key_filter 
#(
   .CNT_MAX (21'd1999_999)
)
key_ctrl_flag_inst      
( 
    .sys_clk    (clk_50m  ) ,
    .sys_rst_n  (rst_n_locked ) ,
    .key_in     (key_ctrl_in    ) ,

    .key_flag   (key_ctrl_flag)
);

key_filter 
#(
   .CNT_MAX (21'd1999_999)
)
key_add_flag_inst      
(
    .sys_clk    (clk_50m   ) ,
    .sys_rst_n  (rst_n_locked ) ,
    .key_in     (key_add_in    ) ,

    .key_flag   (key_add_flag)
    );

time_set TIME_SET_INST
(
    .  clk             ( clk_50m           ) ,
    .  rst_n           ( rst_n_locked         ) ,
    .  key_ctrl_flag   ( key_ctrl_flag ) ,
    .  key_add_flag    ( key_add_flag  ) ,

    .     set_data  (set_data ) ,
    .     set_pos   (set_pos  ) ,
    .     set_flag  (set_flag ) ,
    .     work_en   (work_en  )
);

clk_data_gen CLK_DATA_GEN_INST
(
   .clk  (clk_50m    ),
   .rst_n(rst_n_locked),
   .set_data(set_data),
   .set_pos(set_pos),
   .set_flag(set_flag),
   .work_en(work_en),

   .point(point),
   .data (data ),
   .sign (sign )  
);

data_trans DATA_TRANS_INST
(
    .data  (data),
    .clk  (clk_108m) ,
    .rst_n (rst_n_locked),

    .data0(data0),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .data5(data5)
);

PIX_DATA PIX_DATA_INST
(
    .clk  (clk_108m),
    .rst_n(rst_n_locked),
    .data0(data0),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .data5(data5),
    .x_loc(x_loc),
    .y_loc(y_loc),
    .char_data(char_data),

    .char_num      (char_num     ),     
    .pix_data      (pix_data     ),
    .char_x_loc    (char_x_loc   ),
    .char_y_loc    (char_y_loc   ),    
    .char_data_req (char_data_req) 
);

VGA_CTRL VGA_CTRL
(
    .clk        (clk_108m),
    .rst_n      (rst_n_locked),
    .pix_data   (pix_data),

    .rgb_565      (rgb_565     ),
    .hsync        (hsync       ), 
    .vsync        (vsync       ),
    .x_loc        (x_loc       ),
    .y_loc        (y_loc       ),       // 位宽设置大一点以便于分辨率的修改
    .pix_data_req (pix_data_req)
);

CHAR_DATA CHAR_DATA
(
    .clk          (clk_108m       ),
    .rst_n        (rst_n_locked   ),
    .char_x_loc   (char_x_loc   ),
    .char_y_loc   (char_y_loc   ),
    .char_data_req(char_data_req),
    .char_num     (char_num     ),

    .char_data (char_data) 
);

endmodule