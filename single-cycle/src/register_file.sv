// Asnychronous read, synchronous write
module register_file #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 5
)(
    input clk,
    input we,
    input  [AWIDTH-1:0] addrA,
    input  [AWIDTH-1:0] addrB,
    input  [AWIDTH-1:0] addrD,
    input  [DWIDTH-1:0] dataD,
    output [DWIDTH-1:0] dataA,
    output [DWIDTH-1:0] dataB
);

    reg [DWIDTH-1:0] registers [2**AWIDTH-1:0];

    initial begin
        for (int i = 0; i < 2**AWIDTH; i++)
            registers[i] = 0;
    end

    wire not_zero = |addrD;
    always @(posedge clk)
        if (we & not_zero)
            registers[addrD] <= dataD;

    assign dataA = registers[addrA];
    assign dataB = registers[addrB];

endmodule