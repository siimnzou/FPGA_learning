`timescale 1ns/1ns
module tb_iic_ctrl();

reg           clk                         ;
reg           rst_n                       ;
reg  [7:0]    data                        ;
reg  [15:0]   addr                        ;
reg           wr_en                       ;
reg           rd_en                       ;
wire [6:0]    dev_addr  = 7'b1010011      ;
wire          done_flag                   ;                      
wire          scl                         ;
wire          sda                         ;
wire [7:0]    rd_data_reg                 ;  

initial
    begin
        clk     =   1'b1;
        rst_n   <=  1'b0;
        wr_en    <=  1'b0;
        rd_en    <=  1'b0;
        data        <=  8'b0;
        addr        <=  16'h0;
        #200
        rst_n   <= 1'b1;
        #2000
        data        <=  8'b01010101;
        addr        <=  16'h0002;
        wr_en    <=  1'b1;
        #20
        wr_en    <= 1'b0;  
        #200000
        rd_en   <= 1'b1;
        #20
        rd_en <= 1'b0;
    end

always #10 clk = ~clk;

iic_ctrl  iic_ctrl_inst
(
. clk        (clk  ) ,
. rst_n      (rst_n) ,
. wr_en      (wr_en  ) ,
. dev_addr   (dev_addr ) ,
. addr       (addr     ) ,
. data       (data     ) ,
. addr_num   (1'b0 ) ,
. rd_en      (rd_en  ) ,

. scl    ( scl    )    ,    
. sda        ( sda        ) ,  
. done_flag  ( done_flag  ) ,
. rd_data_reg( rd_data_reg)
);

at24c16_core at24c16_core_inst
(
        .scl     (scl)  ,
        .sda     (sda)  ,
        .wp      (1'b0)  ,
        .a0      (1'b0)  ,
        .a1      (1'b0)  ,
        .a2      (1'b0)      );

endmodule