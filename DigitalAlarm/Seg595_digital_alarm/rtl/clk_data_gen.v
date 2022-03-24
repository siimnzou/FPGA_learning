module clk_data_gen
(
    input clk,
    input rst_n,

    output wire [5:0]  point,
    output wire  [19:0] data,
    output wire sign    
);

parameter CNT_1S_MAX   = 26'd49_999_999,
          CNT_S_MAX    =   6'd59,
          CNT_M_MAX    =   6'd59,
          CNT_H_MAX    =   5'd23;

reg [25:0] cnt_1s;    // 确定1s为基本计时单位
reg [5:0]  cnt_s;     // 记录当前的秒数
reg [5:0]  cnt_m;     // 记录当前的分钟数
reg [4:0]  cnt_h;     // 记录当前的秒钟数

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_1s <= 26'd0;
    else if (cnt_1s == CNT_1S_MAX)
        cnt_1s <= 26'd0;
    else 
        cnt_1s <= cnt_1s + 1'b1;    
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_s <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX)
        cnt_s <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX )
        cnt_s <= cnt_s + 1'b1; 
    else 
        cnt_s <= cnt_s;   
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_m <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX  && cnt_m == CNT_M_MAX)
        cnt_m <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX)
        cnt_m <= cnt_m + 1'b1; 
    else 
        cnt_m <= cnt_m;   
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_h <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX  && cnt_m == CNT_M_MAX && cnt_h == CNT_H_MAX)
        cnt_h <= 6'd0;
    else if (cnt_1s == CNT_1S_MAX  && cnt_s == CNT_S_MAX && cnt_m == CNT_M_MAX)
        cnt_h <= cnt_h + 1'b1; 
    else 
        cnt_h <= cnt_h;   
end

assign data = cnt_s + cnt_m * 100 + cnt_h *10000;

assign point = 6'b101011;
assign sign  = 1'b0;

endmodule