// 根据波形图和卡诺图可以简化表达式为 q = ~(a ^ b ^ c ^ d);
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = ~(a ^ b ^ c ^ d); // Fix me

endmodule