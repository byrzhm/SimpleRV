`ifndef ALU_OPS
`define ALU_OPS

`define ALUOP_WIDTH     4

// ***** ALU operations *****
`define ALU_ADD         4'b0000
`define ALU_SUB         4'b0001
`define ALU_AND         4'b0010
`define ALU_OR          4'b0011
`define ALU_XOR         4'b0100
`define ALU_SLL         4'b0101  // Shift Left Logical
`define ALU_SRL         4'b0110  // Shift Right Logical
`define ALU_SRA         4'b0111  // Shift Right Arithmetic
`define ALU_SLT         4'b1000  // Set Less Than
`define ALU_SLTU        4'b1001  // Set Less Than Unsigned
`define ALU_A           4'b1010  // A input
`define ALU_B           4'b1011  // B input

`endif