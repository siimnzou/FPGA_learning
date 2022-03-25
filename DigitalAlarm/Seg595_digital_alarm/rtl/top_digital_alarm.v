module top_digital_alarm
(
    input clk,
    input rst_n,
    input key_ctrl_in,
    input key_add_in,
    
    output wire stcp,
    output wire shcp,
    output wire ds,  
    output wire oe   
);



wire       sign;
wire [5:0] point;
wire [19:0] data;
wire [5:0]  sel;
wire [7:0]  seg;
wire        key_ctrl_flag;
wire        key_add_flag;
wire [3:0] set_data;
wire [2:0] set_pos;
wire       set_flag;
wire        work_en;

key_filter 
#(
   .CNT_MAX (20'd999_999)
)
key_ctrl_flag_inst      
(
    .sys_clk    (clk   ) ,
    .sys_rst_n  (rst_n ) ,
    .key_in     (key_ctrl_in    ) ,

    .key_flag   (key_ctrl_flag)
);

key_filter 
#(
   .CNT_MAX (20'd999_999)
)
key_add_flag_inst      
(
    .sys_clk    (clk   ) ,
    .sys_rst_n  (rst_n ) ,
    .key_in     (key_add_in    ) ,

    .key_flag   (key_add_flag)
);

time_set time_set_inst
(
    .  clk             ( clk           ) ,
    .  rst_n           ( rst_n         ) ,
    .  key_ctrl_flag   ( key_ctrl_flag ) ,
    .  key_add_flag    ( key_add_flag  ) ,

    .     set_data  (set_data ) ,
    .     set_pos   (set_pos  ) ,
    .     set_flag  (set_flag ) ,
    .     work_en   (work_en  )
);

clk_data_gen clk_data_gen_inst
(
   .clk  (clk  ),
   .rst_n(rst_n),
   .set_data(set_data),
   .set_pos(set_pos),
   .set_flag(set_flag),
   .work_en(work_en),

   .point(point),
   .data (data ),
   .sign (sign )  
);

data_trans data_trans_inst
(
    . data  (data ),
    . clk   (clk  ),
    . rst_n (rst_n),
    . sign  (sign ),    // 1表示负号 ， 0表示正号（不显示）
    . point (point),

    .sel (sel),
    .seg (seg)
);

hc595_ctrl hc595_ctrl_inst
(
    .clk    (clk  )    ,
    .rst_n  (rst_n)    ,
    .sel    (sel )    ,
    .seg    (seg)    ,  

    .stcp (stcp),
    .shcp (shcp),
    .ds    (ds),
    .oe    (oe)
);

endmodule