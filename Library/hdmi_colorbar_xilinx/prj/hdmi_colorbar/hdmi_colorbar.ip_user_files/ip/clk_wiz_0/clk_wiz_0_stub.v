// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Aug  9 10:37:15 2022
// Host        : WINDOWS-LUUTAQT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               g:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(par_clk, ser_clk, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="par_clk,ser_clk,reset,locked,clk_in1" */;
  output par_clk;
  output ser_clk;
  input reset;
  output locked;
  input clk_in1;
endmodule
