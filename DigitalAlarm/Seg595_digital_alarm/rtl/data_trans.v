module data_trans
(
    input [19:0] data,
    input        clk,
    input        rst_n,
    input        sign,    // 1表示负号 ， 0表示正号（不显示）
    input [5:0]  point,

    output reg [5:0]  sel,
    output reg [7:0]  seg
);

parameter CNT_1MS_MAX = 16'd50000;
parameter ZERO   = 8'hc0,
          ONE    = 8'hf9,
          TWO    = 8'ha4,
          THREE  = 8'hb0,
          FOUR   = 8'h99,
          FIVE   = 8'h92,
          SIX    = 8'h82,
          SENVEN = 8'hf8,
          EIGHT  = 8'h80,
          NING   = 8'h90,
          SIGN   = 8'b1011_1111,  
          NONE   = 8'hff;
wire [3:0] data0,data1,data2,data3,data4,data5;
reg  [23:0 ] data_reg;
reg  [15:0 ] cnt_clk;
reg  [2 :0 ]  cnt_sel;
reg  [3 :0 ]  disp_num; // 4'd10 代表负号 4'd11 表示不显示

// 此处可以替换为更加节省资源的BCD转换方法

assign data0  =  data % 10;
assign data1  = (data/10) % 10;
assign data2  = (data/100) % 10;
assign data3  = (data/1000) % 10;
assign data4  = (data/10000) % 10;
assign data5  = (data/100000) % 10;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data_reg <= 24'd0;
    else if (sign == 1'b0 && data5 != 4'd0) 
        data_reg <= {data5,data4,data3,data2,data1,data0};
    else if (sign == 1'b1 && data4 != 4'd0)
        data_reg <= {4'd10,data4,data3,data2,data1,data0};
    else if (sign == 1'b0 && data4 != 4'd0)
        data_reg <= {4'd11,data4,data3,data2,data1,data0};
    else if (sign == 1'b1 && data3 != 4'd0)
        data_reg <= {4'd11,4'd10,data3,data2,data1,data0};
    else if (sign == 1'b0 && data3 != 4'd0)
        data_reg <= {4'd11,4'd11,data3,data2,data1,data0};
    else if (sign == 1'b1 && data2 != 4'd0)
        data_reg <= {4'd11,4'd11,4'd10,data2,data1,data0};
    else if (sign == 1'b0 && data2 != 4'd0)
        data_reg <= {4'd11,4'd11,4'd11,data2,data1,data0};
    else if (sign == 1'b1 && data1 != 4'd0)
        data_reg <= {4'd11,4'd11,4'd11,4'd10,data1,data0};
    else if (sign == 1'b0 && data1 != 4'd0)
        data_reg <= {4'd11,4'd11,4'd11,4'd11,data1,data0};
    else if (sign == 1'b1 && data0 != 4'd0)
        data_reg <= {4'd11,4'd11,4'd11,4'd11,4'd10,data0};
    else if (sign == 1'b0 && data0 != 4'd0)
        data_reg <= {4'd11,4'd11,4'd11,4'd11,4'd11,data0};
    else 
        data_reg <= {4'd11,4'd11,4'd11,4'd11,4'd11,4'd0};
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_clk <= 16'd0;
    else if (cnt_clk == CNT_1MS_MAX - 1)
        cnt_clk <= 16'd0;
    else 
        cnt_clk <= cnt_clk + 1'b1;
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_sel <= 3'd0;
    else if (cnt_clk == CNT_1MS_MAX - 1 && cnt_sel == 3'd5)
        cnt_sel <= 3'd0;
    else if (cnt_clk == CNT_1MS_MAX - 1)
        cnt_sel <= cnt_sel + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        sel <= 6'b000_000;
    else
        case (cnt_sel)
            3'd0 : sel<= 6'b000_001;
            3'd1 : sel<= 6'b000_010;
            3'd2 : sel<= 6'b000_100;
            3'd3 : sel<= 6'b001_000;
            3'd4 : sel<= 6'b010_000;
            3'd5 : sel<= 6'b100_000;
            default: sel <= 6'b000_000;
        endcase
end

// 赋每个数码管要显示的数值

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        disp_num <= 4'd1111;
    else
        case (cnt_sel)
            3'd0 : disp_num <= data_reg[3 :0 ] ;
            3'd1 : disp_num <= data_reg[7 :4 ] ;
            3'd2 : disp_num <= data_reg[11:8 ] ;
            3'd3 : disp_num <= data_reg[15:12] ;
            3'd4 : disp_num <= data_reg[19:16] ;
            3'd5 : disp_num <= data_reg[23:20] ;
            default: disp_num <= 4'd1111;
        endcase
end 

// 根据disp_num 来使得数码管显示对应数值显示

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        seg <= 8'b11111111;
    else 
        case(disp_num)
            4'd0 : seg <= ZERO   ;
            4'd1 : seg <= ONE    ;
            4'd2 : seg <= TWO    ;
            4'd3 : seg <= THREE  ;
            4'd4 : seg <= FOUR   ;
            4'd5 : seg <= FIVE   ;
            4'd6 : seg <= SIX    ;
            4'd7 : seg <= SENVEN ;
            4'd8 : seg <= EIGHT  ;
            4'd9 : seg <= NING   ;
            4'd10: seg <= SIGN   ;
            4'd11: seg <= NONE   ;
            default: seg <= NONE ;
        endcase
end

endmodule