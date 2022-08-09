# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 3
set_param simulator.modelsimInstallPath D:/FPGA/modelsim/win64
set_param synth.incrementalSynthesisCache C:/Users/Administrator/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-21900-WINDOWS-LUUTAQT/incrSyn
set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7z020clg400-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir G:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.cache/wt [current_project]
set_property parent.project_path G:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo g:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  G:/xilinx_FPGA_prj/hdmi_colorbar/rtl/encode_1.v
  G:/xilinx_FPGA_prj/hdmi_colorbar/rtl/hdmi_ctrl.v
  G:/xilinx_FPGA_prj/hdmi_colorbar/rtl/par_to_ser.v
  G:/xilinx_FPGA_prj/hdmi_colorbar/rtl/vga_ctrl.v
  G:/xilinx_FPGA_prj/hdmi_colorbar/rtl/vga_pic.v
  G:/xilinx_FPGA_prj/hdmi_colorbar/rtl/hdmi_colorbar.v
}
read_ip -quiet g:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all g:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all g:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all g:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc G:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.srcs/constrs_1/new/hdmi_colorbar.xdc
set_property used_in_implementation false [get_files G:/xilinx_FPGA_prj/hdmi_colorbar/prj/hdmi_colorbar/hdmi_colorbar.srcs/constrs_1/new/hdmi_colorbar.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top hdmi_colorbar -part xc7z020clg400-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef hdmi_colorbar.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file hdmi_colorbar_utilization_synth.rpt -pb hdmi_colorbar_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]