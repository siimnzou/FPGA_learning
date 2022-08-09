module hdmi_colorbar
(
input wire      sys_clk,
input wire      sys_rst_n,

 output wire        hdmi_r_p ,
 output wire        hdmi_r_n ,
 output wire        hdmi_g_p ,
 output wire        hdmi_g_n ,
 output wire        hdmi_b_p ,
 output wire        hdmi_b_n ,
 output wire        hdmi_clk_p ,
 output wire        hdmi_clk_n ,
 output wire        ddc_scl,
 output wire        ddc_sda
);

wire vga_clk ;
wire clk_5x  ;
wire locked  ;
wire rst_n   ;
wire [9:0]  pix_x;
wire [9:0]  pix_y;
wire        hsync;
wire        vsync;
wire        rgb_valid;
wire [15:0] vga_rgb ;
wire [15:0] pix_data;


clk_wiz_0 clk_gen_inst
   (
    // Clock out ports
    .par_clk(vga_clk),     // output par_clk vga_clk    
    .ser_clk(clk_5x),      // output clk_5x
    // Status and control signals
    .reset(~sys_rst_n), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk));      // input clk_in1

assign rst_n = (sys_rst_n & locked);


 vga_pic    vga_pic_inst
(
    . vga_clk   (vga_clk)    ,
    . sys_rst_n (rst_n)    , 
    . pix_x     (pix_x )    ,
    . pix_y     (pix_y )    ,

    .pix_data   (pix_data)
);

 vga_ctrl  vga_ctrl_inst
(
       . vga_clk    ( vga_clk  ) ,
       . sys_rst_n  ( rst_n) ,
       . pix_data   ( pix_data ) ,
                     
       . pix_x      ( pix_x    ) ,
       . pix_y      ( pix_y    ) ,
       . hsync      ( hsync    ) ,
       . vsync      ( vsync    ) ,
       . rgb_valid  (rgb_valid ) ,
       . vga_rgb    ( vga_rgb  )
);

hdmi_ctrl   hdmi_ctrl_inst
(
 . vga_clk    (vga_clk  ) ,
 . clk_5x     (clk_5x   ) ,
 . sys_rst_n  (rst_n) ,
 . hsync      (hsync    ) ,
 . vsync      (vsync    ) ,
 . rgb_valid  (rgb_valid) ,
 . rgb_blue   ({vga_rgb[4:0],3'b000}) ,  
 . rgb_green  ({vga_rgb[10:5],2'b00}) ,  
 . rgb_red    ({vga_rgb[15:11],3'b000}) ,

 . hdmi_r_p   (hdmi_r_p  ) ,
 . hdmi_r_n   (hdmi_r_n  ) ,
 . hdmi_g_p   (hdmi_g_p  ) ,
 . hdmi_g_n   (hdmi_g_n  ) ,
 . hdmi_b_p   (hdmi_b_p  ) ,
 . hdmi_b_n   (hdmi_b_n  ) ,
 . hdmi_clk_p (hdmi_clk_p) ,
 . hdmi_clk_n (hdmi_clk_n)
);

assign ddc_scl = 1'b1;
assign ddc_sda = 1'b1;

endmodule