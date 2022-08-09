module vga_ctrl
(
        input   wire         vga_clk     ,
        input   wire         sys_rst_n   ,
        input   wire [15:0]  pix_data    ,
        
        output  wire [9:0]   pix_x       ,
        output  wire [9:0]   pix_y       ,
        output  wire         hsync       ,
        output  wire         vsync       ,
        output  wire         rgb_valid   ,
        output  wire [15:0]  vga_rgb
        );
        
parameter   H_SYNC      =   10'd96   ,
            H_BACK      =   10'd40   ,
            H_LEFT      =   10'd8    ,
            H_VALID     =   10'd640  ,
            H_RIGHT     =   10'd8    ,
            H_FRONT     =   10'd8    ,
            H_TOTLE     =   10'd800  ;

parameter  V_SYNC      =   10'd2     ,
           V_BACK      =   10'd25    ,
           V_TOP      =   10'd8     ,
           V_VALID     =   10'd480   ,
           V_BOTTON     =   10'd8     ,
           V_FRONT     =   10'd2     ,
           V_TOTLE     =   10'd525   ;


       
    reg [9:0]   cnt_h       ;
    reg [9:0]   cnt_v       ;

    wire        pix_data_req;
    

always@(posedge vga_clk or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        cnt_h <= 10'd0;
    else if (cnt_h == (H_TOTLE - 1'b1))
        cnt_h <= 10'd0;
    else
        cnt_h <= cnt_h + 1'b1;

always@(posedge vga_clk or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        cnt_v <= 10'd0;
    else if ((cnt_v == V_TOTLE - 1'b1) && (cnt_h == H_TOTLE - 1'b1))
        cnt_v <= 10'd0;
    else if (cnt_h == H_TOTLE - 1'b1)
        cnt_v <= cnt_v + 1'b1;
        

assign rgb_valid = (((cnt_h >= H_SYNC + H_BACK + H_LEFT ) 
        && (cnt_h  < H_SYNC + H_BACK + H_LEFT + H_VALID)) 
        &&((cnt_v >= V_SYNC + V_BACK + V_TOP)
        &&(cnt_v < V_SYNC + V_BACK + V_TOP + V_VALID)))
        ? 1'b1 : 1'b0;

assign  pix_data_req = (((cnt_h >= H_SYNC + H_BACK + H_LEFT - 1'b1 ) 
        && (cnt_h  < H_SYNC + H_BACK + H_LEFT + H_VALID - 1'b1)) 
        &&((cnt_v >= V_SYNC + V_BACK + V_TOP)
        &&(cnt_v < V_SYNC + V_BACK + V_TOP + V_VALID)))
        ? 1'b1 : 1'b0;
       
assign pix_x = ( pix_data_req == 1'b1)? (cnt_h - (H_SYNC + H_BACK + H_LEFT - 1'b1)) : (10'h3ff);

assign pix_y = ( rgb_valid == 1'b1)? (cnt_v - (V_SYNC + V_BACK + V_TOP)) : (10'h3ff);
  
assign vga_rgb = (rgb_valid == 1'b1)? (pix_data) : (16'h0000); 

assign hsync = (cnt_h <= H_SYNC - 1'b1) ? 1'b1 : 1'b0   ;

assign vsync = (cnt_v <= V_SYNC - 1'b1) ? 1'b1 : 1'b0   ;

endmodule