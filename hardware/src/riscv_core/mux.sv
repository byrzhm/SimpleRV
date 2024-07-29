module mux2to1 #(
    parameter DWIDTH = 32
) (
    input [DWIDTH-1:0] in0,
    input [DWIDTH-1:0] in1,
    input sel,
    output [DWIDTH-1:0] out
);
    assign out = sel ? in1 : in0;
endmodule

module mux4to1 #(
    parameter DWIDTH = 32
) (
    input [DWIDTH-1:0] in0,
    input [DWIDTH-1:0] in1,
    input [DWIDTH-1:0] in2,
    input [DWIDTH-1:0] in3,
    input [1:0] sel,
    output [DWIDTH-1:0] out
);
    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b10) ? in2 :
                 in3;
endmodule
