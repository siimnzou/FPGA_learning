module pix_data_gen
(
    input wire          clk_33m         ,
    input wire          rst_n           , 
    input wire  [9:0]   pix_x           ,
    input wire  [9:0]   pix_y           ,
    input wire [15:0]   touch_x_loc     ,
    input wire [15:0]   touch_y_loc     ,
    input wire          touch_req_valid , // 读到了信号就拉高

    output reg          touch_data_req  , 
    output reg [15:0]   pix_data
);

parameter CNT_S_MAX = 26'd33_300_000;
parameter CNT_REQ_MAX = 22'd3_330_000;

// 横竖有效坐标以及颜色定义
parameter   H_VALID = 10'd800   ,
            V_VALID = 10'd480   ;
          
parameter RED       =  16'hf800 ,
          ORANGE    =  16'hfc00 ,  
          YELLOW    =  16'hffe0 ,
          GREEN     =  16'h07e0 ,
          CYAN      =  16'h07ff ,
          BLUE      =  16'h001f ,
          PURPPLE   =  16'hf81f ,
          BLACK     =  16'h0000 ,
          WHITE     =  16'hffff ,
          GRAY      =  16'hd69a ;

reg   [25:0]   cnt_s;
reg   [2:0]    s_count;
reg            cnt_s_en;
reg            colorbar_en;
reg   [21:0]   cnt_req;      // 用于发送异步FIFO的信号读取信号 10ms 一次
 
always @(posedge clk_33m or negedge rst_n) begin
    if (~rst_n)
        cnt_req <= 22'd0;
    else if (cnt_req == CNT_REQ_MAX)
        cnt_req <= 22'd0;
    else 
        cnt_req <= cnt_req + 1'b1;
end

always @(posedge clk_33m or negedge rst_n) begin
    if(~rst_n)
        touch_data_req <= 1'b0;
    else if (cnt_req == CNT_REQ_MAX)
        touch_data_req <= 1'b1;
    else 
        touch_data_req <= 1'b0;
end

always @(posedge clk_33m or negedge rst_n) begin
    if (~rst_n)
        cnt_s <= 26'd0;
    else if (cnt_s_en && cnt_s == CNT_S_MAX )
        cnt_s <= 26'd0;
    else if (cnt_s_en)
        cnt_s <= cnt_s + 1'b1;
end

always @(posedge clk_33m or negedge rst_n) begin
    if (~rst_n)
        s_count <= 3'd0;
    else if (cnt_s == CNT_S_MAX && s_count == 3'd2)
        s_count <= 3'd0;
    else if (cnt_s == CNT_S_MAX)
        s_count <= s_count + 1'b1;
end

always @(posedge clk_33m or negedge rst_n) begin
    if(~rst_n)
        cnt_s_en <= 1'b0;
    else if (touch_req_valid)
        cnt_s_en <= 1'b1;
    else if (cnt_s == CNT_S_MAX && s_count == 3'd2)
        cnt_s_en <= 1'b0;
end

always @(posedge clk_33m or negedge rst_n) begin
    if (~rst_n)
        colorbar_en <= 1'b1;
    else if (touch_req_valid)
        colorbar_en <= 1'b0;
    else if (cnt_s == CNT_S_MAX && s_count == 3'd2)
        colorbar_en <= 1'b1;
end

always@ (posedge clk_33m or negedge rst_n) begin
    if (rst_n == 1'b0)
        pix_data <= BLACK;
    else if (colorbar_en) begin
        if (pix_x >= 0 && pix_x < ((H_VALID/10)*1))
            pix_data <= RED;
        else if (pix_x >= ((H_VALID/10)*1) && pix_x < ((H_VALID/10)*2))
            pix_data <= ORANGE;    
        else if (pix_x >= ((H_VALID/10)*2) && pix_x < ((H_VALID/10)*3))
            pix_data <= YELLOW ; 
        else if (pix_x >= ((H_VALID/10)*3) && pix_x < ((H_VALID/10)*4))
            pix_data <= GREEN; 
        else if (pix_x >= ((H_VALID/10)*4) && pix_x < ((H_VALID/10)*5))
            pix_data <= CYAN;            
        else if (pix_x >= ((H_VALID/10)*5) && pix_x < ((H_VALID/10)*6))
            pix_data <= BLUE;
        else if (pix_x >= ((H_VALID/10)*6) && pix_x < ((H_VALID/10)*7))
            pix_data <= PURPPLE;            
        else if (pix_x >= ((H_VALID/10)*7) && pix_x < ((H_VALID/10)*8))
            pix_data <= BLACK;    
        else if (pix_x >= ((H_VALID/10)*8) && pix_x < ((H_VALID/10)*9))
            pix_data <= WHITE;    
        else if (pix_x >= ((H_VALID/10)*9) && pix_x < ((H_VALID/10)*10))
            pix_data <= GRAY;  
        end
    else if (~colorbar_en) begin
        if (touch_x_loc >= 0 && touch_x_loc < ((H_VALID/10)*1))
            pix_data <= RED;
        else if (touch_x_loc >= ((H_VALID/10)*1) && touch_x_loc < ((H_VALID/10)*2))
            pix_data <= ORANGE;    
        else if (touch_x_loc >= ((H_VALID/10)*2) && touch_x_loc < ((H_VALID/10)*3))
            pix_data <= YELLOW ; 
        else if (touch_x_loc >= ((H_VALID/10)*3) && touch_x_loc < ((H_VALID/10)*4))
            pix_data <= GREEN; 
        else if (touch_x_loc >= ((H_VALID/10)*4) && touch_x_loc < ((H_VALID/10)*5))
            pix_data <= CYAN;            
        else if (touch_x_loc >= ((H_VALID/10)*5) && touch_x_loc < ((H_VALID/10)*6))
            pix_data <= BLUE;
        else if (touch_x_loc >= ((H_VALID/10)*6) && touch_x_loc < ((H_VALID/10)*7))
            pix_data <= PURPPLE;            
        else if (touch_x_loc >= ((H_VALID/10)*7) && touch_x_loc < ((H_VALID/10)*8))
            pix_data <= BLACK;    
        else if (touch_x_loc >= ((H_VALID/10)*8) && touch_x_loc < ((H_VALID/10)*9))
            pix_data <= WHITE;    
        else if (touch_x_loc >= ((H_VALID/10)*9) && touch_x_loc < ((H_VALID/10)*10))
            pix_data <= GRAY;  
        end
    end
endmodule          