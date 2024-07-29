`include "imm_types.vh"

module immgen (
    input      [               31:7] instr,
    input      [`IMM_TYPE_WIDTH-1:0] imm_sel,
    output reg [               31:0] imm_out
);

  always @(*) begin
    case (imm_sel)
      `IMM_I:  imm_out = {{21{instr[31]}}, instr[30:20]};
      `IMM_S:  imm_out = {{21{instr[31]}}, instr[30:25], instr[11:7]};
      `IMM_B:  imm_out = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
      `IMM_U:  imm_out = {instr[31:12], 12'b0};
      `IMM_J:  imm_out = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
      default: imm_out = 0;
    endcase
  end

endmodule
