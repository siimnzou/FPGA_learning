module tft_ctrl
(
        input   wire         clk_33m     ,
        input   wire         sys_rst_n   ,
        input   wire [15:0]  pix_data    ,
        
        output  wire [9:0]   pix_x       ,
        output  wire [9:0]   pix_y       ,
        output  wire         hsync       ,
        output  wire         vsync       ,
        output  wire [15:0]  tft_rgb     ,
        output  wire         tft_clk      ,
        output  wire         tft_bl        ,    
        output  wire         tft_de       ,
        output  wire         tft_rst      
);  

// 分辨率 800*480
parameter   H_SYNC      =   12'd128   ,
            H_BACK      =   12'd88   ,
            H_VALID     =   12'd800 ,
            H_FRONT     =   12'd40    ,
            H_TOTLE     =   12'd1056  ;

parameter  V_SYNC      =   12'd2     ,
           V_BACK      =   12'd33    ,
           V_VALID     =   12'd480   ,
           V_FRONT     =   12'd10     ,
           V_TOTLE     =   12'd525   ;



/* 分辨率 480*272
parameter   H_SYNC      =   10'd41   ,
            H_BACK      =   10'd2   ,
            H_VALID     =   10'd480  ,
            H_FRONT     =   10'd2    ,
            H_TOTLE     =   10'd525  ;

parameter  V_SYNC      =   10'd10     ,
           V_BACK      =   10'd2    ,
           V_VALID     =   10'd272   ,
           V_FRONT     =   10'd2     ,
           V_TOTLE     =   10'd286   ;
*/

       
    reg [11:0]   cnt_h       ;
    reg [11:0]   cnt_v       ;
    wire        rgb_valid   ;
    wire        pix_data_req;
    

always@(posedge clk_33m or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        cnt_h <= 12'd0;
    else if (cnt_h == (H_TOTLE - 1'b1))
        cnt_h <= 12'd0;
    else
        cnt_h <= cnt_h + 1'b1;
        
assign hsync = (cnt_h <= H_SYNC - 1'b1) ? 1'b1 : 1'b0   ;

always@(posedge clk_33m or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        cnt_v <= 12'd0;
    else if ((cnt_v == V_TOTLE - 1'b1) && (cnt_h == H_TOTLE - 1'b1))
        cnt_v <= 12'd0;
    else if (cnt_h == H_TOTLE - 1'b1)
        cnt_v <= cnt_v + 1'b1;
        

assign rgb_valid = (((cnt_h >= H_SYNC + H_BACK ) 
        && (cnt_h  < H_SYNC + H_BACK  + H_VALID)) 
        &&((cnt_v >= V_SYNC + V_BACK )
        &&(cnt_v < V_SYNC + V_BACK  + V_VALID)))
        ? 1'b1 : 1'b0;

assign  pix_data_req = (((cnt_h >= H_SYNC + H_BACK - 1'b1 ) 
        && (cnt_h  < H_SYNC + H_BACK  + H_VALID - 1'b1)) 
        &&((cnt_v >= V_SYNC + V_BACK)
        &&(cnt_v < V_SYNC + V_BACK + V_VALID)))
        ? 1'b1 : 1'b0;
       
assign pix_x = ( pix_data_req == 1'b1)? (cnt_h - (H_SYNC + H_BACK  - 1'b1)) : (12'h3ff);

assign pix_y = ( pix_data_req == 1'b1)? (cnt_v - (V_SYNC + V_BACK )) : (12'h3ff);
  
assign tft_rgb = (rgb_valid == 1'b1)? (pix_data) : (16'h0000); 



assign vsync = (cnt_v <= V_SYNC - 1'b1) ? 1'b1 : 1'b0   ;

assign tft_de   = rgb_valid;
assign tft_clk  = clk_33m;
assign tft_bl   = sys_rst_n;
assign tft_rst  = 1'b1;

endmodule