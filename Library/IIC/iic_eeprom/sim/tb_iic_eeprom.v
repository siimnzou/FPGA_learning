`timescale 1ns/1ns
module tb_iic_eeprom();
reg clk;
reg rst_n;
reg key_in_wr;
reg key_in_rd;

wire     scl;
wire      sda;
wire     done_flag;
wire       ds ; 
wire       oe  ;
wire       shcp;
wire       stcp;

defparam iic_eeprom_inst.key_filter_inst_wr.CNT_MAX = 20'd999;
defparam iic_eeprom_inst.key_filter_inst_rd.CNT_MAX = 20'd999;
defparam iic_eeprom_inst.CNT_50MS_MAX = 22'd249;
defparam iic_eeprom_inst.CNT_1S_MAX  = 22'd499;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    key_in_wr <= 1'b1;
    key_in_rd <= 1'b1;
    #20
    rst_n <= 1'b1;
    #200
    key_in_wr <= 1'b0;
    #500000
    key_in_wr <= 1'b1;
    #5000
    key_in_rd <= 1'b0;
    #500000
    key_in_rd <= 1'b1;    
end

always #10 clk = ~clk;

iic_eeprom iic_eeprom_inst
(
.clk         (clk        )  ,
.rst_n       (rst_n      )  ,
.key_in_wr   (key_in_wr  )  ,
.key_in_rd   (key_in_rd  )  ,

. scl       (scl      )        ,
. sda       (sda      )        ,
. done_flag (done_flag)        ,
.   ds      (  ds     )    ,
.   oe      (  oe     )    ,
.   shcp    (  shcp   )    ,
.   stcp    (  stcp   )
);

endmodule