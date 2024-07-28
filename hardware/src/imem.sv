// asynchronous read ROM
module imem #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 14
) (
    input [AWIDTH-1:0] addr,
    output [DWIDTH-1:0] instr
);

    reg [DWIDTH-1:0] mem [0:2**AWIDTH-1];

    initial begin
        $readmemh("init_imem.hex", mem);
    end

    assign instr = mem[addr];

endmodule