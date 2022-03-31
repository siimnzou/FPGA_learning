// 水箱控制系统
// 最高 S3 FR全关， 最低后 FR全开 ，当再中间的时候FR取决于
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
// 定义6个状态
parameter ALMOST_FULL       =    6'b000001,    // 处于最高
          ALMOST_EMPTY      =    6'b000010,    // 处于最低
          MID_HIGH_RISE     =    6'b000100,    // S3,S2之间，并且液面上升
          MID_HIGH_FALL     =    6'b001000,    // S3,S2之间，并且液面下降      
          MID_LOW_RISE      =    6'b010000,    // S1,S2之间，并且液面上升 
          MID_LOW_FALL      =    6'b100000;    // S1,S2之间，并且液面下降 

reg [5:0] state;

always @(posedge clk ) begin
    if (reset)
        state <= ALMOST_EMPTY;
    else 
        case (state) 
        ALMOST_EMPTY :
            if (s == 3'b001)
                state <= MID_LOW_RISE;
            else
                state <= ALMOST_EMPTY;
        MID_LOW_RISE  :
            if (s == 3'b011)
                state <= MID_HIGH_RISE;
            else if (s == 3'b000)
                state <= ALMOST_EMPTY;
            else
                state <= MID_LOW_RISE;
        MID_HIGH_RISE  :
            if (s == 3'b111)
                state <= ALMOST_FULL;
            else if (s == 3'b001)
                state <= MID_LOW_FALL;
            else 
                state <= state;
        MID_LOW_FALL :
            if (s == 3'b011)
                state <= MID_HIGH_RISE;
            else if (s == 3'b000)
                state <= ALMOST_EMPTY;
            else 
                state <= MID_LOW_FALL;
        ALMOST_FULL:
            if (s == 3'b011)
                state <= MID_HIGH_FALL;
            else 
                state <= ALMOST_FULL;
        MID_HIGH_FALL:
            if (s == 3'b111)
                state <= ALMOST_FULL;
            else if (s == 3'b001)
                state <= MID_LOW_FALL;
            else
                state <= MID_HIGH_FALL;
        default : state <= ALMOST_EMPTY;
        endcase   
end

always @(*) begin
    case(state)
        ALMOST_FULL  :
            begin
                fr1 = 1'b0;
                fr2 = 1'b0; 
                fr3 = 1'b0;
                dfr = 1'b0;
            end
        ALMOST_EMPTY :
            begin
                fr1 = 1'b1;
                fr2 = 1'b1; 
                fr3 = 1'b1;
                dfr = 1'b1;
            end    
        MID_HIGH_RISE  :
            begin
                fr1 = 1'b1;
                fr2 = 1'b0; 
                fr3 = 1'b0;
                dfr = 1'b0;
            end    
        MID_HIGH_FALL :
            begin
                fr1 = 1'b1;
                fr2 = 1'b0; 
                fr3 = 1'b0;
                dfr = 1'b1;
            end      
        MID_LOW_RISE :
            begin
                fr1 = 1'b1;
                fr2 = 1'b1; 
                fr3 = 1'b0;
                dfr = 1'b0;
            end      
        MID_LOW_FALL  :
            begin
                fr1 = 1'b1;
                fr2 = 1'b1; 
                fr3 = 1'b0;
                dfr = 1'b1;
            end           
        default: 
            begin
                fr1 = 1'b0;
                fr2 = 1'b0; 
                fr3 = 1'b0;
                dfr = 1'b0;
            end
        endcase
end

endmodule