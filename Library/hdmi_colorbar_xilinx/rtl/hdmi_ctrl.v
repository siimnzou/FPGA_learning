module hdmi_ctrl
(
 input wire         vga_clk,
 input wire         clk_5x,
 input wire         sys_rst_n,
 input wire         hsync,
 input wire         vsync,
 input wire         rgb_valid,
 input wire [7:0]   rgb_blue,  
 input wire [7:0]   rgb_green,  
 input wire [7:0]   rgb_red,

 output wire        hdmi_r_p ,
 output wire        hdmi_r_n ,
 output wire        hdmi_g_p ,
 output wire        hdmi_g_n ,
 output wire        hdmi_b_p ,
 output wire        hdmi_b_n ,
 output wire        hdmi_clk_p ,
 output wire        hdmi_clk_n 
);


//------------------------------<根据TMDS协议将RGB信号进行编码>------------------------------

wire [9:0]  data_out_r;
wire [9:0]  data_out_g;
wire [9:0]  data_out_b;

encode_1 encode_1_r
(
  .clkin     (vga_clk)   ,    // pixel clock input
  .rstin     (~sys_rst_n)   ,    // async. reset input (active high)
  .din       (rgb_red)   ,      // data inputs: expect registered
  .c0        (hsync)   ,         // c0 input
  .c1        (vsync)   ,       // c1 input
  .de        (rgb_valid)   ,       // de input
  .dout      (data_out_r)       // data outputs
);

encode_1 encode_1_g
(
  .clkin     (vga_clk)   ,    // pixel clock input
  .rstin     (~sys_rst_n)   ,    // async. reset input (active high)
  .din       (rgb_green)   ,      // data inputs: expect registered
  .c0        (1'b0)   ,         // c0 input
  .c1        (1'b0)   ,       // c1 input
  .de        (rgb_valid)   ,       // de input
  .dout      (data_out_g)       // data outputs
);

encode_1 encode_1_b
(
  .clkin     (vga_clk)   ,    // pixel clock input
  .rstin     (~sys_rst_n)   ,    // async. reset input (active high)
  .din       (rgb_blue)   ,      // data inputs: expect registered
  .c0        (1'b0)   ,         // c0 input
  .c1        (1'b0)   ,       // c1 input
  .de        (rgb_valid)   ,       // de input
  .dout      (data_out_b)       // data outputs
);

//------------------------------<使用Xilinx原语言进行并串转换>------------------------------

wire serial_data_red;
wire serial_data_green;
wire serial_data_blue;
wire serial_data_clk;

par_to_ser par_to_ser_red(
    .par_clk (vga_clk),  // 并行时钟
    .ser_clk (clk_5x),  // 串行时钟
    .rst_n   (sys_rst_n),
    .par_data(data_out_r),

    .ser_data (serial_data_red)
);

par_to_ser par_to_ser_green(
    .par_clk (vga_clk),  // 并行时钟
    .ser_clk (clk_5x),  // 串行时钟
    .rst_n   (sys_rst_n),
    .par_data(data_out_g),

    .ser_data (serial_data_green)
);

par_to_ser par_to_ser_blue(
    .par_clk (vga_clk),  // 并行时钟
    .ser_clk (clk_5x),  // 串行时钟
    .rst_n   (sys_rst_n),
    .par_data(data_out_b),

    .ser_data (serial_data_blue)
);

par_to_ser par_to_ser_clk(
    .par_clk (vga_clk),  // 并行时钟
    .ser_clk (clk_5x),  // 串行时钟
    .rst_n   (sys_rst_n),
    .par_data(10'b11111_00000),

    .ser_data (serial_data_clk)
);



//------------------------------<使用Xilinx原语言将信号变成差分信号>------------------------------

OBUFDS 
#(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
) 
OBUFDS_red 
(
      .O(hdmi_r_p),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_r_n),   // Diff_n output (connect directly to top-level port)
      .I(serial_data_red)      // Buffer input
   );

OBUFDS 
#(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
) 
OBUFDS_green 
(
      .O(hdmi_g_p),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_g_n),   // Diff_n output (connect directly to top-level port)
      .I(serial_data_green)      // Buffer input
   );

OBUFDS 
#(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
) 
OBUFDS_blue 
(
      .O(hdmi_b_p),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_b_n),   // Diff_n output (connect directly to top-level port)
      .I(serial_data_blue)      // Buffer input
   );

OBUFDS 
#(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
) 
OBUFDS_clk 
(
      .O(hdmi_clk_p),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_clk_n),   // Diff_n output (connect directly to top-level port)
      .I(serial_data_clk)      // Buffer input
   );

endmodule