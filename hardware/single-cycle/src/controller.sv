`include "../src/opcode.vh"
`include "../src/imm_types.vh"
`include "../src/alu_ops.vh"
`include "../src/control_signals.vh"

module controller #(
    parameter DWIDTH = 32
) (
    // instruction input
    input [DWIDTH-1:0] instr,

    // pc mux select
    output reg pc_sel,

    // imm mux select
    output reg [`IMM_TYPE_WIDTH-1:0] imm_sel,

    // register file write enable
    output reg rf_we,

    // comparator signals
    input br_eq,
    input br_lt,
    output reg br_un,

    // alu inputs select
    output reg a_sel,
    output reg b_sel,

    // alu signals
    output reg [`ALUOP_WIDTH-1:0] alu_sel,

    // dmem signals
    output reg [DWIDTH/8-1:0] dmem_wbe,
    output reg [2:0] ld_sel,

    // writeback mux select
    output reg [1:0] wb_sel
);

    always @(*) begin

        // initial values
        pc_sel = `PC_PLUS_4; // PC + 4
        imm_sel = `IMM_I;    // I-type
        rf_we = 1;           // write register file
        br_un = 0;           // signed comparison
        a_sel = `A_REG;      // register A
        b_sel = `B_REG;      // register B
        alu_sel = `ALU_ADD;  // ALU_ADD
        dmem_wbe = 0;        // no write
        ld_sel = `STR_WORD;  // load STR_WORD
        wb_sel = `WB_ALU;    // ALU result

        case (instr[6:0])
            `OPC_LUI: begin
                imm_sel = `IMM_U;
                b_sel = `B_IMM;
                alu_sel = `ALU_B;
            end

            `OPC_AUIPC: begin
                imm_sel = `IMM_U;
                a_sel = `A_PC;
                b_sel = `B_IMM;
                alu_sel = `ALU_ADD;
            end

            `OPC_JAL: begin
                imm_sel = `IMM_J;
                a_sel = `A_PC;
                b_sel = `B_IMM;
                alu_sel = `ALU_ADD;
                pc_sel = `PC_ALU;
                wb_sel = `WB_PC;
            end

            `OPC_JALR: begin
                imm_sel = `IMM_I;
                b_sel = `B_IMM;
                alu_sel = `ALU_ADD;
                pc_sel = `PC_ALU;
                wb_sel = `WB_PC;
            end

            `OPC_BRANCH: begin
                imm_sel = `IMM_B;
                rf_we = 0;
                a_sel = `A_PC;
                b_sel = `B_IMM;
                alu_sel = `ALU_ADD;
                case (instr[14:12])
                    `FNC_BEQ: if (br_eq) pc_sel = `PC_ALU; 
                    `FNC_BNE: if (!br_eq) pc_sel = `PC_ALU;
                    `FNC_BLT: if (br_lt) pc_sel = `PC_ALU;
                    `FNC_BGE: if (!br_lt) pc_sel = `PC_ALU;
                    `FNC_BLTU: begin
                        br_un = 1; // unsigned comparison
                        if (br_lt) pc_sel = `PC_ALU;
                    end
                    `FNC_BGEU: begin
                        br_un = 1; // unsigned comparison
                        if (!br_lt) pc_sel = `PC_ALU;
                    end
                endcase
            end

            `OPC_STORE: begin
                imm_sel = `IMM_S;
                rf_we = 0;
                b_sel = `B_IMM;
                alu_sel = `ALU_ADD;
                case (instr[14:12])
                    `FNC_SB: dmem_wbe = `STR_BYTE;
                    `FNC_SH: dmem_wbe = `STR_HALF;
                    `FNC_SW: dmem_wbe = `STR_WORD;
                endcase
            end

            `OPC_LOAD: begin
                imm_sel = `IMM_I;
                b_sel = `B_IMM;
                alu_sel = `ALU_ADD;
                wb_sel = `WB_MEM;
                case (instr[14:12])
                    `FNC_LB: ld_sel = `LD_BYTE;
                    `FNC_LH: ld_sel = `LD_HALF;
                    `FNC_LW: ld_sel = `LD_WORD;
                    `FNC_LBU: ld_sel = `LD_BYTE_UN;
                    `FNC_LHU: ld_sel = `LD_HALF_UN;
                endcase
            end

            `OPC_ARI_RTYPE: begin
                case (instr[14:12])
                    `FNC_ADD_SUB: begin
                        case (instr[31:25]) // funct7
                            `FNC7_0: alu_sel = `ALU_ADD;
                            `FNC7_1: alu_sel = `ALU_SUB;
                        endcase
                    end

                    `FNC_SLL: alu_sel = `ALU_SLL;
                    `FNC_SLT: alu_sel = `ALU_SLT;
                    `FNC_SLTU: alu_sel = `ALU_SLTU;
                    `FNC_XOR: alu_sel = `ALU_XOR;
                    `FNC_OR: alu_sel = `ALU_OR;
                    `FNC_AND: alu_sel = `ALU_AND;
                    `FNC_SRL_SRA: begin
                        case (instr[31:25]) // funct7
                            `FNC7_0: alu_sel = `ALU_SRL;
                            `FNC7_1: alu_sel = `ALU_SRA;
                        endcase
                    end
                endcase
            end

            `OPC_ARI_ITYPE: begin
                imm_sel = `IMM_I;
                b_sel = `B_IMM;
                case (instr[14:12])
                    `FNC_ADD_SUB: alu_sel = `ALU_ADD; // no SUBI
                    `FNC_SLL: alu_sel = `ALU_SLL;
                    `FNC_SLT: alu_sel = `ALU_SLT;
                    `FNC_SLTU: alu_sel = `ALU_SLTU;
                    `FNC_XOR: alu_sel = `ALU_XOR;
                    `FNC_OR: alu_sel = `ALU_OR;
                    `FNC_AND: alu_sel = `ALU_AND;
                    `FNC_SRL_SRA: begin
                        case (instr[31:25]) // funct7
                            `FNC7_0: alu_sel = `ALU_SRL;
                            `FNC7_1: alu_sel = `ALU_SRA;
                        endcase
                    end
                endcase
            end

        endcase

    end

endmodule