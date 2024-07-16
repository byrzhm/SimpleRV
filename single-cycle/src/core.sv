`include "../src/alu_ops.vh"

module core #(
    parameter RESET_PC = 32'h00000000
) (
    input clk,
    input rst
);
    localparam DWIDTH = 32;

    // 32-bit PC, 0.004KB
    localparam PC_WIDTH = 32;
    wire [DWIDTH-1:0] pc, pc_next;
    REGISTER_R #(
        .N(DWIDTH), .INIT(RESET_PC))
    PC (
        .q(pc),
        .d(pc_next),
        .rst(rst),
        .clk(clk)
    );
    wire [DWIDTH-1:0] pc_plus_4 = pc + 4;


    // 32 32-bit registers -> 32 * 4B = 0.125KB
    localparam RF_AWIDTH = 5;
    wire [4:0] rf_addr_a, rf_addr_b, rf_addr_d;
    wire [31:0] rf_data_a, rf_data_b;
    wire [31:0] rf_data_d;
    wire rf_we;
    register_file #(
        .DWIDTH(DWIDTH),
        .AWIDTH(RF_AWIDTH))
    RF (
        .clk(clk),
        .we(rf_we),
        .addrA(rf_addr_a),
        .addrB(rf_addr_b),
        .addrD(rf_addr_d),
        .dataD(rf_data_d),
        .dataA(rf_data_a),
        .dataB(rf_data_b)
    );

    // 2^14 * 4B = 64KB IMEM
    localparam IMEM_AWIDTH = 14;
    wire [DWIDTH-1:0] instr;
    imem #(
        .DWIDTH(DWIDTH),
        .AWIDTH(IMEM_AWIDTH))
    IMEM (
        .addr(pc[IMEM_AWIDTH-1:2]),
        .instr(instr)
    );


    // 2^14 * 4B = 64KB DMEM
    localparam DMEM_AWIDTH = 14;
    wire [DWIDTH-1:0] dmem_dw, dmem_dr;
    wire [DMEM_AWIDTH-1:0] dmem_addr;
    wire [DWIDTH/8-1:0] dmem_wbe;
    dmem #(
        .DWIDTH(DWIDTH),
        .AWIDTH(DMEM_AWIDTH))
    DMEM (
        .wbe(dmem_wbe),
        .addr(dmem_addr),
        .dataw(dmem_dw),
        .datar(dmem_dr),
        .clk(clk)
    );

    // ALU
    wire [DWIDTH-1:0] alu_a_in, alu_b_in;
    wire [DWIDTH-1:0] alu_out;
    wire [`ALUOP_WIDTH-1:0] alu_sel;
    alu #(
        .DWIDTH(DWIDTH))
    ALU (
        .a(alu_a_in),
        .b(alu_b_in),
        .alu_op(alu_sel),
        .y(alu_out)
    );

    // Immediate generation
    wire [DWIDTH-1:0] imm;
    wire [`IMM_TYPE_WIDTH-1:0] imm_sel;
    immgen IMMGEN (
        .instr(instr[31:7]),
        .imm_sel(imm_sel),
        .imm_out(imm)
    );

    // Branch Comparator
    wire br_un, br_eq, br_lt;
    comparator #(
        .DWIDTH(DWIDTH))
    COMP (
        .a(rf_data_a),
        .b(rf_data_b),
        .br_un(br_un),
        .br_eq(br_eq),
        .br_lt(br_lt)
    );

    // Controller
    wire pc_sel, a_sel, b_sel;
    wire [2:0] ld_sel;
    wire [1:0] wb_sel;
    controller #(
        .DWIDTH(DWIDTH))
    CONTROLLER (
        .instr(instr),
        .pc_sel(pc_sel),
        .imm_sel(imm_sel),
        .rf_we(rf_we),
        .br_eq(br_eq),
        .br_lt(br_lt),
        .br_un(br_un),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .alu_sel(alu_sel),
        .dmem_wbe(dmem_wbe),
        .ld_sel(ld_sel),
        .wb_sel(wb_sel)
    );

    // Connect Register File
    assign rf_addr_a = instr[19:15];
    assign rf_addr_b = instr[24:20];
    assign rf_addr_d = instr[11:7];

    // PC Mux
    mux2to1 #(
        .DWIDTH(DWIDTH))
    PC_MUX (
        .in0(pc_plus_4),
        .in1(alu_out),
        .sel(pc_sel),
        .out(pc_next)
    );

    // A MUX
    mux2to1 #(
        .DWIDTH(DWIDTH))
    A_MUX (
        .in0(rf_data_a),
        .in1(pc),
        .sel(a_sel),
        .out(alu_a_in)
    );

    // B MUX
    mux2to1 #(
        .DWIDTH(DWIDTH))
    B_MUX (
        .in0(rf_data_b),
        .in1(imm),
        .sel(b_sel),
        .out(alu_b_in)
    );

    // Connect DMEM
    assign dmem_addr = alu_out;
    assign dmem_dw = rf_data_b;

    // Load MUX
    wire [DWIDTH-1:0] mem_out;
    loadmux #(
        .DWIDTH(DWIDTH))
    LD_MUX (
        .in(dmem_dr),
        .ld_sel(ld_sel),
        .out(mem_out)
    );

    // Writeback MUX
    mux4to1 #(
        .DWIDTH(DWIDTH))
    WB_MUX (
        .in0(mem_out),
        .in1(alu_out),
        .in2(pc_plus_4),
        .in3({DWIDTH{1'b0}}),
        .sel(wb_sel),
        .out(rf_data_d)
    );
    
endmodule