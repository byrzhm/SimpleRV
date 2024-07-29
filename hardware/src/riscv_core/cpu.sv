`include "alu_ops.vh"

module cpu #(
    parameter CPU_CLOCK_FREQ = 50_000_000,
    parameter RESET_PC = 32'h1000_0000,
    parameter BAUD_RATE = 115_200,
    parameter PROG_MIF_HEX = ""
) (
    input clk,
    input rst,

    // IO Ports
    output [3:0] leds,
    input serial_in,
    output serial_out
);
  localparam DWIDTH = 32;

  //-------------PC--------------
  wire [DWIDTH-1:0] pc, pc_next;
  wire [DWIDTH-1:0] pc_plus_4 = pc + 4;
  REGISTER_R #(
      .N(DWIDTH),
      .INIT(RESET_PC)
  ) PC (
      .q  (pc),
      .d  (pc_next),
      .rst(rst),
      .clk(clk)
  );


  //-----------------Register File-----------------
  localparam RF_AWIDTH = 5;
  wire [4:0] rf_addr_1, rf_addr_2, rf_addr_3;
  wire [31:0] rf_data_1, rf_data_2;
  wire [31:0] rf_data_3;
  wire rf_we;
  register_file #(
      .DWIDTH(DWIDTH),
      .AWIDTH(RF_AWIDTH)
  ) RF (
      .clk(clk),
      .we(rf_we),
      .addr1(rf_addr_1),
      .data1(rf_data_1),
      .addr2(rf_addr_2),
      .data2(rf_data_2),
      .addr3(rf_addr_3),
      .data3(rf_data_3)
  );

  //-----------------Instruction Memory-----------------
  localparam IMEM_AWIDTH = 10;
  wire [IMEM_AWIDTH-1:0] imem_addr;
  wire [DWIDTH-1:0] imem_dout;
  wire [DWIDTH-1:0] instr = imem_dout;
  imem #(
      .DWIDTH(DWIDTH),
      .AWIDTH(IMEM_AWIDTH),
      .PROG_MIF_HEX(PROG_MIF_HEX)
  ) IMEM (
      .addr(imem_addr),
      .dout(imem_dout)
  );


  //-----------------Data Memory-----------------
  localparam DMEM_AWIDTH = 10;
  wire dmem_en;
  wire [DWIDTH-1:0] dmem_din, dmem_dout;
  wire [DMEM_AWIDTH-1:0] dmem_addr;
  wire [DWIDTH/8-1:0] dmem_wbe;
  dmem #(
      .DWIDTH(DWIDTH),
      .AWIDTH(DMEM_AWIDTH)
  ) DMEM (
      .wbe (dmem_wbe),
      .en  (dmem_en),
      .addr(dmem_addr),
      .din (dmem_din),
      .dout(dmem_dout),
      .clk (clk)
  );

  //-----------------ALU-----------------
  wire [DWIDTH-1:0] alu_a_in, alu_b_in;
  wire [DWIDTH-1:0] alu_out;
  wire [`ALUOP_WIDTH-1:0] alu_sel;
  alu #(
      .DWIDTH(DWIDTH)
  ) ALU (
      .a(alu_a_in),
      .b(alu_b_in),
      .alu_op(alu_sel),
      .y(alu_out)
  );

  //-----------------Immediate Generation-----------------
  wire [DWIDTH-1:0] imm;
  wire [`IMM_TYPE_WIDTH-1:0] imm_sel;
  immgen IMMGEN (
      .instr  (instr[31:7]),
      .imm_sel(imm_sel),
      .imm_out(imm)
  );

  //------------------Branch Comparator------------------
  wire br_un, br_eq, br_lt;
  comparator #(
      .DWIDTH(DWIDTH)
  ) COMP (
      .a(rf_data_1),
      .b(rf_data_2),
      .br_un(br_un),
      .br_eq(br_eq),
      .br_lt(br_lt)
  );

  //-----------------IO Controller-----------------
  localparam IO_AWIDTH = 10;
  wire io_en;
  wire [IO_AWIDTH-1:0] io_addr;
  wire [DWIDTH-1:0] io_din, io_dout;
  wire [3:0] io_wbe;
  io_ctrl #(
      .DWIDTH(DWIDTH),
      .AWIDTH(IO_AWIDTH)
  ) IO_CTRL (
      .clk(clk),
      .rst(rst),
      .en(io_en),
      .addr(io_addr),
      .din(io_din),
      .wbe(io_wbe),
      .dout(io_dout),
      .leds(leds),
      .serial_in(serial_in),
      .serial_out(serial_out)
  );

  //-----------------Controller-----------------
  wire pc_sel, a_sel, b_sel;
  wire [1:0] st_sel;
  wire [2:0] ld_sel;
  wire [1:0] wb_sel;
  controller #(
      .DWIDTH(DWIDTH)
  ) CONTROLLER (
      .instr  (instr),
      .pc_sel (pc_sel),
      .imm_sel(imm_sel),
      .rf_we  (rf_we),
      .br_eq  (br_eq),
      .br_lt  (br_lt),
      .br_un  (br_un),
      .a_sel  (a_sel),
      .b_sel  (b_sel),
      .alu_sel(alu_sel),
      .st_sel (st_sel),
      .ld_sel (ld_sel),
      .wb_sel (wb_sel)
  );

  //-----------------Connections-----------------

  // PC Mux
  mux2to1 #(
      .DWIDTH(DWIDTH)
  ) PC_MUX (
      .in0(pc_plus_4),
      .in1(alu_out),
      .sel(pc_sel),
      .out(pc_next)
  );

  // PC -> IMEM
  assign imem_addr = pc[2+:IMEM_AWIDTH];

  // IMEM -> Register File
  assign rf_addr_1 = instr[19:15];
  assign rf_addr_2 = instr[24:20];
  assign rf_addr_3 = instr[11:7];

  // A MUX
  mux2to1 #(
      .DWIDTH(DWIDTH)
  ) A_MUX (
      .in0(rf_data_1),
      .in1(pc),
      .sel(a_sel),
      .out(alu_a_in)
  );

  // B MUX
  mux2to1 #(
      .DWIDTH(DWIDTH)
  ) B_MUX (
      .in0(rf_data_2),
      .in1(imm),
      .sel(b_sel),
      .out(alu_b_in)
  );

  // DMEM & IO
  wire is_io = (alu_out[31] == 1'b1);

  // Store Mux
  wire [1:0] byte_offset = alu_out[1:0];
  wire [DWIDTH-1:0] stx_dout;
  wire [DWIDTH/8-1:0] stx_wbe;
  stx STX (
    .din(rf_data_2),
    .byte_offset(byte_offset),
    .st_sel(st_sel),
    .dout(stx_dout),
    .wbe(stx_wbe)
  );

  assign dmem_addr = alu_out[2+:DMEM_AWIDTH];
  assign dmem_din  = rf_data_2;
  assign dmem_en = ~is_io;
  assign dmem_wbe = stx_wbe;

  assign io_addr = alu_out[2+:IO_AWIDTH];
  assign io_din  = rf_data_2;
  assign io_en = is_io;
  assign io_wbe = stx_wbe;

  // IO DMEM Mux
  wire [DWIDTH-1:0] io_dmem_mux_out;
  mux2to1 #(
      .DWIDTH(DWIDTH)
  ) IO_DMEM_MUX (
      .in0(dmem_dout),
      .in1(io_dout),
      .sel(is_io),
      .out(io_dmem_mux_out)
  );

  // Load MUX
  wire [DWIDTH-1:0] mem_out;
  ldx LDX (
      .in(io_dmem_mux_out),
      .byte_offset(byte_offset),
      .ld_sel(ld_sel),
      .out(mem_out)
  );


  // Writeback MUX
  mux4to1 #(
      .DWIDTH(DWIDTH)
  ) WB_MUX (
      .in0(mem_out),
      .in1(alu_out),
      .in2(pc_plus_4),
      .in3({DWIDTH{1'b0}}),
      .sel(wb_sel),
      .out(rf_data_3)
  );

endmodule
