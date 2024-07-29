`include "control_signals.vh"

module stx (
    input [31:0] din,
    input [1:0] byte_offset,
    input [1:0] st_sel,
    output reg [31:0] dout,
    output reg [3:0] wbe
);

  always @(*) begin
    case (byte_offset)
      2'd0: dout = din;
      2'd1: dout = {din[23:0], 8'h00};
      2'd2: dout = {din[15:0], 16'h0000};
      2'd3: dout = {din[7:0], 24'h000000};
    endcase
  end

  reg [3:0] tmp;

  always @(*) begin
    tmp = 4'b0000;
    case (st_sel)
      `ST_BYTE: tmp = 4'b0001;
      `ST_HALF: tmp = 4'b0011;
      `ST_WORD: tmp = 4'b1111;
    endcase

    wbe = tmp << byte_offset;
  end

endmodule
