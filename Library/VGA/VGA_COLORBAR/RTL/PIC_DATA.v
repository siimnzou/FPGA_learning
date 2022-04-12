 module PIC_DATA
 (
    input           clk,
    input           rst_n,
    input [11:0]    x_loc,
    input [11:0]    y_loc,

    output reg [15:0] pix_data
 );

parameter H_VALID  =  12'd1280,
          V_VALID  =  12'd1024;

parameter BLACK         =   16'h0000,  
          PINK          =   16'hfe19,  
          PURPLE        =   16'h8010,  
          NAVY_BLUE     =   16'h10  ,  // 海军蓝
          EMERALD_GREEN =   16'h471a,  // 宝石绿
          GOLD          =   16'hfea0,  
          DARK_RED      =   16'h8800,  // 深红色
          WHITE         =   16'hffff,
          ORANGE        =   16'hfc00,
          GRAY          =   16'hd69a; 

always@(*) begin
    if (~rst_n)
        pix_data <= BLACK;
    else if (x_loc > (H_VALID/10)*0 && x_loc <= (H_VALID/10)*1 )
        pix_data <= BLACK;
    else if (x_loc > (H_VALID/10)*1 && x_loc <= (H_VALID/10)*2 )
        pix_data <= PINK;
    else if (x_loc > (H_VALID/10)*2 && x_loc <= (H_VALID/10)*3)
        pix_data <= PURPLE;
    else if (x_loc > (H_VALID/10)*3 && x_loc <= (H_VALID/10)*4 )
        pix_data <= NAVY_BLUE;
    else if (x_loc > (H_VALID/10)*4 && x_loc <= (H_VALID/10)*5 )
        pix_data <= EMERALD_GREEN;
    else if (x_loc > (H_VALID/10)*5 && x_loc <= (H_VALID/10)*6 )
        pix_data <= GOLD;
    else if (x_loc > (H_VALID/10)*6 && x_loc <= (H_VALID/10)*7 )
        pix_data <= DARK_RED;
    else if (x_loc > (H_VALID/10)*7 && x_loc <= (H_VALID/10)*8 )
        pix_data <= WHITE;
    else if (x_loc > (H_VALID/10)*8 && x_loc <= (H_VALID/10)*9 )
        pix_data <= ORANGE;
    else if (x_loc > (H_VALID/10)*9 && x_loc <= (H_VALID/10)*10 )
        pix_data <= GRAY;
    else 
        pix_data <= BLACK;
end

endmodule