`timescale 1ns/1ns
module tb_time_set();

reg        clk;
reg        rst_n;
reg        key_add_flag;
reg        key_ctrl_flag;

wire [3:0] set_data;
wire [2:0] set_pos;
wire       set_flag;
wire        work_en;
wire [5:0] point;
wire [19:0] data ; 
wire        sign ; 

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    key_ctrl_flag  <= 1'b0;
    key_add_flag   <= 1'b0;
    #20
    rst_n <= 1'b1;
    #200
    // IDLE - S_L_SET
    key_ctrl_flag <= 1'b1;
    #20
    key_ctrl_flag <= 1'b0;
    #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
    #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
        #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
        #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
        #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
        #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
        #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
        #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
    #200
    // S_L-SET - S_H_SET
    key_ctrl_flag <= 1'b1;
    #20
    key_ctrl_flag <= 1'b0;
           #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0; 
        #200
    // S_H-SET - M_L_SET
    key_ctrl_flag <= 1'b1;
    #20
    key_ctrl_flag <= 1'b0;
           #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0; 
        #200
    // M_L-SET - M_H_SET
    key_ctrl_flag <= 1'b1;
    #20
    key_ctrl_flag <= 1'b0;
           #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0; 
        #200
    // M_H-SET - H_L_SET
    key_ctrl_flag <= 1'b1;
    #20
    key_ctrl_flag <= 1'b0;
           #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0; 
        #200
    // H_L-SET - H_H_SET
    key_ctrl_flag <= 1'b1;
    #20
    key_ctrl_flag <= 1'b0;
           #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0;
            #200
    key_add_flag <= 1'b1;
    #20
    key_add_flag <= 1'b0; 
        // H_H-SET - IDLE
    key_ctrl_flag <= 1'b1;
    #20
    key_ctrl_flag <= 1'b0;
end

always #10 clk = ~ clk;

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

endmodule