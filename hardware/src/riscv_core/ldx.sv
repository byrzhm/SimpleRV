`include "control_signals.vh"

module ldx (
    input [31:0] in,
    input [2:0] ld_sel,
    input [1:0] byte_offset,
    output reg [31:0] out
);

  reg [31:0] shift_data;

  always @(*) begin
    case (byte_offset)
      2'd0: shift_data = in;
      2'd1: shift_data = {8'h00, in[31:8]};
      2'd2: shift_data = {16'h0000, in[31:16]};
      2'd3: shift_data = {24'h000000, in[31:24]};
    endcase

    case (ld_sel)
      `LD_BYTE: out = {{24{shift_data[7]}}, shift_data[7:0]};
      `LD_BYTE_UN: out = {{24{1'b0}}, shift_data[7:0]};
      `LD_HALF: out = {{16{shift_data[15]}}, shift_data[15:0]};
      `LD_HALF_UN: out = {{16{1'b0}}, shift_data[15:0]};
      `LD_WORD: out = shift_data;
      default: out = {32{1'bx}};
    endcase
  end

endmodule
