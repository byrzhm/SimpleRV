// asynchronous read ROM
module imem #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 10,
    parameter PROG_MIF_HEX = ""
) (
    input  [AWIDTH-1:0] addr,
    output [DWIDTH-1:0] dout
);

  reg [DWIDTH-1:0] mem[0:2**AWIDTH-1];

  integer i;
  initial begin
    if (PROG_MIF_HEX != "") begin
      $readmemh(PROG_MIF_HEX, mem);
    end else begin
      for (i = 0; i < 2 ** AWIDTH; i = i + 1) begin
        mem[i] = 0;
      end
    end
  end

  assign dout = mem[addr];

endmodule
