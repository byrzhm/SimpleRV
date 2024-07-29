`ifndef CONTROL_SIGNALS
`define CONTROL_SIGNALS

`define    ST_BYTE        2'b01
`define    ST_HALF        2'b10
`define    ST_WORD        2'b11
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