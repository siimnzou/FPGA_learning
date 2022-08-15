// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Mon Aug 15 10:32:18 2022
// Host        : Zou running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_50_to_clk_33_sim_netlist.v
// Design      : clk_50_to_clk_33
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "clk_50_to_clk_33,fifo_generator_v13_2_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_7,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    almost_full,
    empty,
    almost_empty);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 core_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME core_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [15:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [15:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE ALMOST_FULL" *) output almost_full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ ALMOST_EMPTY" *) output almost_empty;

  wire almost_empty;
  wire almost_full;
  wire clk;
  wire [15:0]din;
  wire [15:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire wr_en;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [5:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [5:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [5:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "1" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "6" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "16" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "16" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "1" *) 
  (* C_HAS_ALMOST_FULL = "1" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "0" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "0" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "1" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "1" *) 
  (* C_PRELOAD_REGS = "0" *) 
  (* C_PRIM_FIFO_TYPE = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "62" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "61" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "6" *) 
  (* C_RD_DEPTH = "64" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "6" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "6" *) 
  (* C_WR_DEPTH = "64" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "6" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_fifo_generator_v13_2_7 U0
       (.almost_empty(almost_empty),
        .almost_full(almost_full),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(clk),
        .data_count(NLW_U0_data_count_UNCONNECTED[5:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(1'b0),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[5:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(1'b0),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(1'b0),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[5:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
RgPKnWr9n0dGgttm3akiFhAlfB96usOQYxnEmPhGyTGg1AbizYAjGPWLXBWl50n/d0IA71ci4aJB
wt6mtfyNADm3ZReK7D3mKu037BOgxryoEwwf1kiC6q/PllxsdAgEMfQrfHJ3E2AzSpdYjoxVYito
y0JW6CUDcWvWa4WV0EA=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
M0l6KpOGH3jL8eRt3NCD7e2USYnkg5H9GAnE1PKmnjiouFN3Y8kjWA2PZDAQLm9UW+TsC1HeVlzO
WjNCHkjR/6ubCsIcWfpPZWdIuAenlsyq8Y9l6b8vMj8JSbDEOiFF/GHSbKsn22MJdDJKEhHFK6GV
s8gR2vywRFwG69gIRE4qGhVB+WIg8GJrDpDMYH6lCjMkTrjXuKDUcNlJN3NPLuhJ7tsditwf1pr5
moJRmGpJnip/rGm0g4o4A6ev4CtePjoao8C1wFtzHkERX9oenhh7cGjDMejU5IrLv8NxFnLj1FpB
9MuF1beTU20NI5oAn6zLiLiOtXjf0ghU3AN4DA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
hAsrUfp6Qgjm8yBjNYTEtQmVQmMxzL8TE/3oiQSxSI3+yEkXAbQCXkT9mo+LCdv+fGECOB0istHd
eLtbsiYbxjxNxYkXiUrRE5O+aSxynIray+uF9DJigTEUZu8JJXUbzxK4DDUu1Lm9tpGps4+Prz1m
0gkj13RT/Y/418s2VTw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BP/54Wm/GJmb1jy0bxWJJX4aiKyiWPVh4X3VL30BQrmX4PlEsNKzBJH3Qu8IIYERfnFP0ifAgboa
vypMQ5Ed0BrMePGkWIgT6I8hxJCMFpHdkSK7m1giSKyZzFfTOrVqoNFXE+qdzLfY1J5hBWCvouYo
jllavK4N3gF9FLScH2AUWYVMcVth2QPaTAU2NLnAUNH8kgtBjBfc8/KbPPTznD1QNVqvFstzcbTA
hGQ1ETVPvINQ0KqxxAG5PRhtQD4+pC+hr/Tvk+RSvGyBOfy9zE86OXkJiYs9dSFhNiMFmCPL9DBO
se4OxNNC0/7aBtb1mkSEA9YFDYEb9jS7Jasy2A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
SnzT9DVH3xlEN8nrr2YrlvTO5qj7L22d7WaBcuKyTaiHoIwwFHrC4HQbfs0TAwkdWcOgmJoATPSF
F6qm0KiddbrlERF3MfKUldeGBJtqLdX+zGw7+3JD7S+HB9dIMOFOHy+IiCZp1/Pz8epKpi238cel
rcVoJQKz406wmXDvOo8KsT+XhRLs9BVCrBErPGGXKYDk6NXAp0duOgQE9DbslzMU83M/kUC7uERV
tQW02240peKQFp2elEZC7Tetvgp0TaFTtJiKN45REi8GQUCKGa85JjNIk1qb/+k95TIIP1xrHirc
6iX7qbwnPetv8TVu2NjkZ0WDEK5RXdOXcxBwHA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
erkR82V0jX8ytva+9MzEs0c75Z7j7TsgxWRLNAUfbbU28i+U9YzuZlSfYU75M0f9jx1gvxtBrfKv
cNHVdkR+i5zfHDZsDwfMEEBhs8wzDCKqe+eex6BBEvlIOesCPXrr2RozQgaQ1PBh/os2Arfu+873
BjsVxFJkbhpzIqlddOo/XZV9Yi+eih7A7pXXEBR6IL7Poo4Ka49MiVQU0xJrDTm+ddOuMPDRRD7g
dsxS/uzdcBcO2myV6g/7YH/C2Ce9s6+UywJN/0JeXSqwA7bsBqqnfFicVAT0lckLopMLiuzK7dsN
EwhFeqoetciFrDIj9+o0xDMWBZhgNP1u68vURA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
R+BI65BKLT0I9hEtsxGnDyM5XY9gzULeTPOSDXvd3KWOzZJAx6C0xlbyZcFZhAEG/QIK2yd0wAi6
IUWxyF/sx3HsqKjhVi5KxnpuXDBOZVoj811O7JukedFVmDW7OHGtBkuiJ5X5irw7mfsEKRQmF/1i
V6lj9HYHZEjxtDeZjACsLY4y1QxWalSKT4HIMOHznBLL8dLbGMlS+ZmFuFn0gcwZavVl7gTkTtkf
W0gn01A9ru7NKsf+iLX0kj4dgItPu9N2g02M1vWQ9UUQEVvfV7lUc7GY1suibrD8aEkhH9S7lZ7n
bFsT4qxyvzg8ML6v4g4v7N6VuyhEtgFgNd725Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
jNUVKiwH68vHsU54idgvKwaVJcoxTUuxfgrQpbpmM/IpesWA3wHsGzYClwAxkKzw3KRnFyQqTWcZ
yj1EQ2CMBxlJ0kyNbZW8OK8pXzeigToZ0U6Aq3Gy+j7wBbhe83wE1Ygn82sK8dHTEulvaRLn/c5r
ispy1s7jMKIvYNzoUuZrgyBQyfaYmdqUia8XlQjFd+VwzhTXKwzvmaqHWyaHjfBKeCooO7+oUxMG
OJg83W54EVe9ronFQ8Wr9EOL8ia7qelCAgyQe/bC0HHCoMAm8apI7sX23iMR/wMiPP5V2bQzycy+
rBX/+SWkqSeIE1FLm+muFPvrE7iLwJaW8d1fzdFFjAZ5aIXArbWNfwbK8S0TczXc9lEzmpb69rwA
UJIrs4alo81qGQ32UFhjuMQjX75O9Od1HWHDj5PFaT/Ja5Ly+bK8Cc3gfO6dCE81m7d+B2JBZ/Hl
tBA19QuOAYwT2EIPOdpaVtCULb33cWODWu3qQFhZMmDzKTb3kwpcr0LL

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MnzcA2swaxH1LRacKDou0ZmiiMRETbWIdHgeBgyQz7ILronsXLoB/C20WuFNGEVSiL2/51EZ6MXZ
vMHI8fFcMQCJcuTBDBibUMKv6bXI9s8fTbtrBZppbF/R1icG5JYhqmX4aRnv4W/dxJRjI2L35nLN
Y48E9OfgfkD1sr+IRwx8WEKFmUhuk8dLe0VOK7ywe3XEcneYvrz+HhPj16bGmNfMwNnDgZ3gKKZD
hRnys+jzvAX3HyISrErWXhMKrhWMxXeTNFJCqNQ0LWAVHQYwyKnF5xVpyXSuGNSIrva+QXqOrZBG
3VNLirNVtMRiKLfwZeMaqvswkqBDAa53utlAAA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
d0xXkKtsKM8GvXhDZr16p1+oE3uBtD04BJ76eGGIEj/CFECfHVy9qsJ43oSKjas0+AJr4GFFnVb6
X7gJV6MmX/OboC9ier5joUCGz0mxVzkRZK9a+LPEDcg0K6+cLE36kr+FfxW9Uk2816EHBCMCf5mK
A4eAhSmAb5Nq74F/q0quiG416npbny7faiQ+xmPDfYYiM3UuMKaD4iE8ODlz1w5xThPllWESf3LZ
NTkw6fozyTqZ47vvE21O3dgIGAY1v+C6BwlCK24VwPJa1xs9csY+qTk31j5jjAc1ExlB6QF7t9UH
lk70qdNPWxT87OH7kFT8UvPO1D6BTC3/WkDZfA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LYhdzKTvo93uJrAaiP5OfCDuOnu2BSvPnxlv6I7h2n1+xHtj34LNNKzWEgOg9dUV9cYDaHYUjjEt
DKdWcz6mZ61d5qyxAhpv67fc90v7JVgtOAcT94/Yb+AuLxXFcGA6Gic7uoJtUgz6JmTnb22Dxdjc
KuIewDj4IOTfP8XGXKTaF+cNp0CFrQgTAcVSQFyLFxr0I/9h3S+GZLecA7ntEeHEOfCJzPvy0ddi
7MCdQWECLb+fXC0IAn8V95TumcpINiRAX1BHi9IGJ4QoMrb3jOCrPkFhDMTJj2aiImUWdi/l/0QE
d7wcXlgIEYVeoKYUOJ4mqy+zZPUbLNeOPADUDQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 84560)
`pragma protect data_block
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
jjuszR7l/MqmQKoDWJ2EgGHScMJBbgM1N0w5zwI=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
