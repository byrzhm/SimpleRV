// asynchronous read and synchronous write
module dmem #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 10
) (
    input                 clk,
    input                 en,
    input  [DWIDTH/8-1:0] wbe,   // write byte enable
    input  [  AWIDTH-1:0] addr,
    input  [  DWIDTH-1:0] din,
    output [  DWIDTH-1:0] dout
);

  reg [DWIDTH-1:0] mem[0:2**AWIDTH-1];

  integer i;
  initial begin
    for (i = 0; i < 2 ** AWIDTH; i++) mem[i] = 0;
  end

  always @(posedge clk) begin
    if (en) begin
      for (i = 0; i < DWIDTH / 8; i++) begin
        if (wbe[i]) mem[addr][i*8+:8] <= din[i*8+:8];
      end
    end
  end

  assign dout = mem[addr];

endmodule
