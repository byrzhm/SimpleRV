`include "../src/control_signals.vh"

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

module loadmux #(
    parameter DWIDTH = 32
) (
    input [DWIDTH-1:0] in,
    input [2:0] ld_sel,
    output reg [DWIDTH-1:0] out
);

    always @(*) begin
        case (ld_sel)
            `LD_BYTE: out = {{24{in[7]}}, in[7:0]};
            `LD_BYTE_UN: out = {{24{1'b0}}, in[7:0]};
            `LD_HALF: out = {{16{in[15]}}, in[15:0]};
            `LD_HALF_UN: out = {{16{1'b0}}, in[15:0]};
            `LD_WORD: out = in;
            default: out = {DWIDTH{1'bx}};
        endcase
    end

endmodule
