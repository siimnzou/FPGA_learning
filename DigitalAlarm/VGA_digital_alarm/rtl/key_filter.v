/*************************************************************
   按键消抖模块，对输入的按键信号进行消抖处理，输出一个表示信号
   参数CNT_MAX 表示从抖动结束到稳定的Clk计数周期
*************************************************************/
module  key_filter
#(
    parameter   CNT_MAX = 21'd1999_999
)
(
    input   wire        sys_clk     ,
    input   wire        sys_rst_n   ,
    input   wire        key_in      ,

    output  reg         key_flag
);

reg     [20:0]  cnt_20ms    ;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_20ms    <=  21'd0;
    else    if(key_in == 1'b1)
        cnt_20ms    <=  21'd0;
    else    if(cnt_20ms == CNT_MAX)
        cnt_20ms    <=  CNT_MAX;
    else
        cnt_20ms    <=  cnt_20ms + 21'd1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        key_flag    <=  1'b0;
    else    if(cnt_20ms == (CNT_MAX - 21'd1))
        key_flag    <=  1'b1;
    else
        key_flag    <=  1'b0;

endmodule