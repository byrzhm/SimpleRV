`include "alu_ops.vh"

module alu #(
    parameter DWIDTH = 32
) (
    input [DWIDTH-1:0] a,
    input [DWIDTH-1:0] b,
    input [`ALUOP_WIDTH-1:0] alu_op,
    output reg [DWIDTH-1:0] y
);
    always @(*) begin
        case (alu_op)
            `ALU_ADD:     y = a + b;
            `ALU_SUB:     y = a - b;
            `ALU_AND:     y = a & b;
            `ALU_OR:      y = a | b;
            `ALU_XOR:     y = a ^ b;
            `ALU_SLL:     y = a << b[4:0];
            `ALU_SRL:     y = a >> b[4:0];
            `ALU_SRA:     y = $signed(a) >>> b[4:0];
            `ALU_SLT:     y = ($signed(a) < $signed(b)) ? 1 : 0;
            `ALU_SLTU:    y = (a < b) ? 1 : 0;
            `ALU_A:       y = a;
            `ALU_B:       y = b;

            default: begin
                y = {DWIDTH{1'bx}};
                $display("ALU: Unknown operation %h", alu_op);
            end
        endcase
    end

endmodule