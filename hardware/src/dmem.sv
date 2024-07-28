// asynchronous read and synchronous write
module dmem #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 14
) (
    input                 clk,
    input  [DWIDTH/8-1:0] wbe, // write byte enable
    input  [AWIDTH-1:0]   addr,
    input  [DWIDTH-1:0]   dataw,
    output [DWIDTH-1:0]   datar
);

    reg [DWIDTH-1:0] mem [0:2**AWIDTH-1];

    integer i;
    initial begin
        for (i = 0; i < 2**AWIDTH; i++)
            mem[i] = 0;
    end

    always @(posedge clk)
        for (i = 0; i < DWIDTH/8; i++)
            if (wbe[i])
                mem[addr][i*8 +: 8] <= dataw[i*8 +: 8];

    assign datar = mem[addr];
    
endmodule