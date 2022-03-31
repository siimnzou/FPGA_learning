// 本模块首先将输入的二进制数据转换为BCD码，然后再转换为串行数据。
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
parameter ZERO   = 7'b1000000,
          ONE    = 7'b1111001,
          TWO    = 7'b0100100,
          THREE  = 7'b0110000,
          FOUR   = 7'b0011001,
          FIVE   = 7'b0010010,
          SIX    = 7'b0000010,
          SENVEN = 7'b1111000,
          EIGHT  = 7'b0000000,
          NING   = 7'b0010000,
          SIGN   = 8'b1011_1111,  
          NONE   = 8'hff;

reg [3:0] data0,data1,data2,data3,data4,data5;
reg  [23:0 ] data_reg;
reg  [15:0 ] cnt_clk;
reg  [2 :0 ]  cnt_sel;
reg  [3 :0 ]  disp_num; // 4'd10 代表负号 4'd11 表示不显示
reg           dot_disp;
reg  [4:0]    cnt_shift;   //用来计数已经移位多少次的计数器 0 来加载数据，21用来赋值。
reg  [43:0]   data_shift;   //6位数码管20位数据+4*6=44位数据
reg           shift_en ;   // 移位使能信号 由于需要等到先判断之后再进行移位，所以必须一个周期判断，一个周期移位

/* // 此处替换为更加节省资源的BCD转换方法
assign data0  =  data % 10;
assign data1  = (data/10) % 10;
assign data2  = (data/100) % 10;
assign data3  = (data/1000) % 10;
assign data4  = (data/10000) % 10;
assign data5  = (data/100000) % 10;
*/

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_shift <= 5'd0;
    else if (shift_en && cnt_shift == 5'd21)
        cnt_shift <= 5'd0;
    else if (shift_en)
        cnt_shift <= cnt_shift + 1'b1;
    else
        cnt_shift <= cnt_shift;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        shift_en <= 1'b0;
    else
        shift_en <= ~shift_en;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data_shift <= 44'b0;
    else if (cnt_shift == 5'd0)
        data_shift <= {24'b0,data};
    else if (cnt_shift <= 5'd20 && !shift_en)
        begin
            data_shift[23:20]   <=  (data_shift[23:20] > 4) ? (data_shift[23:20] + 2'd3) : (data_shift[23:20]);
            data_shift[27:24]   <=  (data_shift[27:24] > 4) ? (data_shift[27:24] + 2'd3) : (data_shift[27:24]);
            data_shift[31:28]   <=  (data_shift[31:28] > 4) ? (data_shift[31:28] + 2'd3) : (data_shift[31:28]);
            data_shift[35:32]   <=  (data_shift[35:32] > 4) ? (data_shift[35:32] + 2'd3) : (data_shift[35:32]);
            data_shift[39:36]   <=  (data_shift[39:36] > 4) ? (data_shift[39:36] + 2'd3) : (data_shift[39:36]);
            data_shift[43:40]   <=  (data_shift[43:40] > 4) ? (data_shift[43:40] + 2'd3) : (data_shift[43:40]);            
        end
    else if (cnt_shift <= 5'd20 && shift_en)
        data_shift <= data_shift << 1;
    else 
        data_shift <= data_shift;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        begin
        data0 <= 4'b0;
        data1 <= 4'b0;
        data2 <= 4'b0;
        data3 <= 4'b0;
        data4 <= 4'b0;
        data5 <= 4'b0;
        end
    else if(cnt_shift == 5'd21)
        begin
        data0  <=  data_shift[23:20];
        data1  <=  data_shift[27:24];
        data2  <=  data_shift[31:28];
        data3  <=  data_shift[35:32];
        data4  <=  data_shift[39:36];
        data5  <=  data_shift[43:40];
        end
end

//以下是将BCD码转换为串行数据


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

// 是否点亮小数点位
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        dot_disp <= 1'b0;
    else 
        dot_disp <= point[cnt_sel];
end

// 根据disp_num 来使得数码管显示对应数值显示
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        seg <= 8'b11111111;
    else 
        case(disp_num)
            4'd0 : seg <= {dot_disp,ZERO  };   
            4'd1 : seg <= {dot_disp,ONE   };
            4'd2 : seg <= {dot_disp,TWO   };
            4'd3 : seg <= {dot_disp,THREE };
            4'd4 : seg <= {dot_disp,FOUR  };
            4'd5 : seg <= {dot_disp,FIVE  };
            4'd6 : seg <= {dot_disp,SIX   };
            4'd7 : seg <= {dot_disp,SENVEN};
            4'd8 : seg <= {dot_disp,EIGHT };
            4'd9 : seg <= {dot_disp,NING  };
            4'd10: seg <= SIGN;
            4'd11: seg <= NONE;
            default: seg <= NONE ;
        endcase
end

endmodule