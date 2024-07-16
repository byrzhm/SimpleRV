`ifndef CONTROL_SIGNALS
`define CONTROL_SIGNALS

`define    STR_BYTE       4'b0001
`define    STR_HALF       4'b0011
`define    STR_WORD       4'b1111
`define    LD_BYTE        3'b000
`define    LD_BYTE_UN     3'b100
`define    LD_HALF        3'b001
`define    LD_HALF_UN     3'b101
`define    LD_WORD        3'b010
`define    A_REG          1'b0
`define    A_PC           1'b1
`define    B_REG          1'b0
`define    B_IMM          1'b1
`define    PC_PLUS_4      1'b0
`define    PC_ALU         1'b1
`define    WB_MEM         2'b00
`define    WB_ALU         2'b01
`define    WB_PC          2'b10

`endif