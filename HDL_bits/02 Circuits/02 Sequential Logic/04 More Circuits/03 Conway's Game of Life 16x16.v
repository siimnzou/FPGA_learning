//该游戏规则是，在二维网格中，每个cell其下一状态由其邻居所决定，0-1：置0 ; 2 ：不变 ; 3 ：置1; 4+：置0;
//本例中采用16x16网格，采用一维向量[15:0]代表第一行，以此类推
module top_module(
    input clk,
    input load,
    input [255:0] data ,
    output [255:0] q ); 

reg [3:0] count;
reg [255:0] q_next;

// 计算邻居数 依次按照 从左到右，从上到下顺序
integer i;
always @(*) begin
    for (i = 0 ; i < 256 ; i = i + 1 ) begin
        if (i == 0) // 左上角时候的邻居数 
            count = q[255]+ q[240] +q[241] +  q[15] + q[1] + q[31] + q[16]  + q[17];
        else if (i == 15) //右上角
            count = q[254] + q[255] + q[240] + q[14] + q[0] + q[30] + q[31] + q[16];
        else if (i == 240) //左下角
            count = q[239] + q[224] + q[225] + q[255] + q[241] + q[15] + q[0] + q[1];
        else if (i == 255) //右下角
            count = q[238] + q[239] + q[224] + q[254] + q[240] + q[14] + q[15] + q[0];
        else if (i > 0 && i < 15) // 第一行非四角的元素 最上部分需要+256
            count = q[256-17+i] + q[256-16+i] + q[256-15+i] + q[i-1]
            + q[i+1] + q[i+15] + q[i+16] + q[i+17]; 
        else if ((i % 16) == 0 ) // 第一列非四角的元素 最左部分需要+16
            count = q[i-17+16] + q[i-16] + q[i-15] + q[i-1+16] + q[i+1] + q[i+15+16] + q[i+16] + q[i+17];
        else if ((i % 16) == 15) // 最后一列非四角元素 最右部分需要-16
            count = q[i-17] + q[i-16] + q[i-15-16] + q[i-1] + q[i+1-16] + q[i+15] + q[i+16] + q[i+17-16];
        else if (i > 240 && i< 255) // 最下一行非四角元素 最下部分需要 - 256
            count = q[i-17] + q[i-16] + q[i-15] + q[i-1] + q[i+1] + q[i+15 -256] + q[i+16-256] + q[i+17-256];
        else 
            count = q[i-17] + q[i-16] + q[i-15] + q[i-1] + q[i+1] + q[i+15] + q[i+16] + q[i+17];
        
        case(count)
            4'd2 : q_next[i] = q[i];
            4'd3 : q_next[i] = 1'b1;
            default : q_next[i] = 1'b0;
        endcase               
    end
end

always@(posedge clk) begin
    if (load)
        q <= data;
    else
        q <= q_next;
end

endmodule