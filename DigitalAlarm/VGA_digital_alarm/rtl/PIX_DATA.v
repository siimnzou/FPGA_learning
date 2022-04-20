/****************************************************************************************************
    用于产生VGA的像素信息，根据数据转换模块输出来的时分秒不同位的数据以及当前扫描到的x坐标和y坐标              
    确定输出给字符数据产生模块的字符x坐标（char_x_loc）、字符y坐标（char_y_loc）、字符数（char_num）
    然后根据CHAR_DATA模块产生的字符信息输出Rgb_565色彩，显示区域为中央位置
    可配置的参数：
    与VGA_CTRL模块同步的VGA时序参数（此处1280x1024@60Hz）
    空白部分与时钟部分的色彩
    字符的大小（需要对应的调整CHAR_DATA中的字符大小）
*****************************************************************************************************/
module PIX_DATA
(
    input clk,
    input rst_n,
    input [3:0]  data0,
    input [3:0]  data1,
    input [3:0]  data2,
    input [3:0]  data3,
    input [3:0]  data4,
    input [3:0]  data5,
    input [11:0]  x_loc,
    input [11:0]  y_loc,
    input         char_data,

    output reg  [3:0]  char_num,     
    output wire  [15:0] pix_data,
    output reg  [9:0]  char_x_loc,
    output reg  [9:0]  char_y_loc,    
    output reg      char_data_req  
);

reg  char_en;

// 行场同步参数
parameter H_VALID = 12'd1280,
          V_VALID = 12'd1024,
          H_CHAR  = 12'd128,     
          V_CHAR  = 12'd128,
          H_DOT   = 12'd32 ,
          V_DOT   = 12'd128;

// 显示色彩
parameter BLACK = 16'h0000,
          WHITE = 16'hFA20;

// 字符大小
parameter CHAR_W = 12'd128,    // 数字宽度
          DOT_W  = 12'd32,     // 冒号宽度
          HIGHT  = 12'd128;     // 数字与冒号的高度

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_data_req <= 1'b0;
    else if (  x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1) 
            && x_loc <  ((H_VALID - (H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1))
            && y_loc >= ((V_VALID - HIGHT)/2 + 1) 
            && y_loc <  ((V_VALID + HIGHT)/2))
        char_data_req <= 1'b1;
    else 
        char_data_req <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_en <= 1'b0;
    else 
        char_en <= char_data_req;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_x_loc <= 10'd0;
    else if (x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 1*CHAR_W + 0*DOT_W) ||
             x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 2*CHAR_W + 0*DOT_W) ||
             x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 2*CHAR_W + 1*DOT_W) ||
             x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 3*CHAR_W + 1*DOT_W) ||
             x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 4*CHAR_W + 1*DOT_W) ||
             x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 4*CHAR_W + 2*DOT_W) ||
             x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 5*CHAR_W + 2*DOT_W) ||
             x_loc == ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 6*CHAR_W + 2*DOT_W) )
        char_x_loc <= 10'd0;
    else if ((x_loc >= (H_VALID - 6*CHAR_W - 2*DOT_W)/2)  
            && (x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 6*CHAR_W + 2*DOT_W))
            && (y_loc >= ((V_VALID - HIGHT)/2 + 1))  
            && (y_loc < ((V_VALID + HIGHT)/2)))
        char_x_loc <= char_x_loc + 1'b1;
    else 
        char_x_loc <= char_x_loc;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_y_loc <= 10'd0;
    else if ((char_y_loc == 10'd127 ) && (x_loc == H_VALID))
        char_y_loc <= 10'd0;
    else if ((y_loc >= ((V_VALID - HIGHT)/2 + 1)) 
            && (y_loc < ((V_VALID + HIGHT)/2))
            && (x_loc == H_VALID))
        char_y_loc <= char_y_loc + 1'b1;
    else 
        char_y_loc <= char_y_loc;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_num <= 4'd0;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 1*CHAR_W + 0*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= data5;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 1*CHAR_W + 0*DOT_W) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 2*CHAR_W + 0*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= data4;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 2*CHAR_W + 0*DOT_W) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 2*CHAR_W + 1*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= 4'd10;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 2*CHAR_W + 1*DOT_W) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 3*CHAR_W + 1*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= data3;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 3*CHAR_W + 1*DOT_W) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 4*CHAR_W + 1*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= data2;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 4*CHAR_W + 1*DOT_W) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 4*CHAR_W + 2*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= 4'd10;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 4*CHAR_W + 2*DOT_W) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 5*CHAR_W + 2*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= data1;
    else if(x_loc >= ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 5*CHAR_W + 2*DOT_W) && x_loc < ((H_VALID - 6*CHAR_W - 2*DOT_W)/2 - 1 + 6*CHAR_W + 2*DOT_W)  && y_loc >= ((V_VALID - HIGHT)/2 + 1)  && y_loc < (V_VALID + HIGHT/2))
        char_num <= data0;
    else 
        char_num <= 4'd0;
end

assign pix_data = (char_en) ? (char_data ? WHITE : BLACK) : BLACK;

endmodule