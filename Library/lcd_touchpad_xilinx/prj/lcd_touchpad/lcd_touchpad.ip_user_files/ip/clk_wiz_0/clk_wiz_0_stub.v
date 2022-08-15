// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Mon Aug 15 10:12:02 2022
// Host        : Zou running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/xilinx_FPGA_prj/lcd_touchpad/prj/lcd_touchpad/lcd_touchpad.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_33m, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_33m,reset,locked,clk_in1" */;
  output clk_33m;
  input reset;
  output locked;
  input clk_in1;
endmodule
