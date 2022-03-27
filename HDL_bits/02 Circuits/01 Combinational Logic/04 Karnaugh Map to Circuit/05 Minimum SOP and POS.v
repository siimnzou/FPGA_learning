// SOP 形式为与或式 ， 对应为卡诺图圈1
// POS 形式为或与式 ， 对应为卡诺图圈0后取反
module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
); 

assign out_sop = (c & d) || (c & !a & !b);
assign out_pos = ~(!c || (!d & a) || (!d & b));

endmodule