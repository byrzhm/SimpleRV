// Asnychronous read, synchronous write
module register_file #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 5
) (
    input clk,
    input we,

    // read
    input  [AWIDTH-1:0] addr1,
    output [DWIDTH-1:0] data1,
    input  [AWIDTH-1:0] addr2,
    output [DWIDTH-1:0] data2,

    // write back
    input [AWIDTH-1:0] addr3,
    input [DWIDTH-1:0] data3
);

  reg [DWIDTH-1:0] mem[2**AWIDTH-1:0];

  initial begin
    for (int i = 0; i < 2 ** AWIDTH; i++) mem[i] = 0;
  end

  wire not_zero = |addr3;
  always @(posedge clk) if (we & not_zero) mem[addr3] <= data3;

  assign data1 = mem[addr1];
  assign data2 = mem[addr2];

endmodule
