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


parameter H_VALID = 12'd1280,
          V_VALID = 12'd1024,
          H_CHAR  = 12'd128,     
          V_CHAR  = 12'd128,
          H_DOT   = 12'd32 ,
          V_DOT   = 12'd128;

parameter BLACK = 16'h0000,
          WHITE = 16'hffff;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_data_req <= 1'b0;
    else if (x_loc >= 12'd223 && x_loc < 12'd1055
            && y_loc >= 12'd449 && y_loc < 12'd576)
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
    else if (x_loc == 12'd351 ||
             x_loc == 12'd479 ||
             x_loc == 12'd511 ||
             x_loc == 12'd639 ||
             x_loc == 12'd767 ||
             x_loc == 12'd799 ||
             x_loc == 12'd927 ||
             x_loc == 12'd1055 )
        char_x_loc <= 10'd0;
    else if (x_loc >= 12'd224 && x_loc < 12'd1055
            && y_loc >= 12'd449 && y_loc < 12'd576)
        char_x_loc <= char_x_loc + 1'b1;
    else 
        char_x_loc <= char_x_loc;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_y_loc <= 10'd0;
    else if (char_y_loc == 10'd127 && x_loc == 12'd1280)
        char_y_loc <= 10'd0;
    else if (y_loc >= 10'd449 && y_loc < 12'd576 && x_loc == 12'd1280)
        char_y_loc <= char_y_loc + 1'b1;
    else 
        char_y_loc <= char_y_loc;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        char_num <= 4'd0;
    else if(x_loc >= 12'd223 && x_loc < 12'd351  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= data5;
    else if(x_loc >= 12'd351 && x_loc < 12'd479  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= data4;
    else if(x_loc >= 12'd479 && x_loc < 12'd511  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= 4'd10;
    else if(x_loc >= 12'd511 && x_loc < 12'd639  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= data3;
    else if(x_loc >= 12'd639 && x_loc < 12'd767  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= data2;
    else if(x_loc >= 12'd767 && x_loc < 12'd799  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= 4'd10;
    else if(x_loc >= 12'd799 && x_loc < 12'd927  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= data1;
    else if(x_loc >= 12'd927 && x_loc < 12'd1055  && y_loc >= 12'd449 && y_loc < 12'd576)
        char_num <= data0;
    else 
        char_num <= 4'd0;
end

assign pix_data = (char_en) ? (char_data ? WHITE : BLACK) : BLACK;

endmodule