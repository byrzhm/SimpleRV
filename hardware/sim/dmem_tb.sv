`timescale 1ns / 1ns

module dmem_tb ();

  parameter DWIDTH = 32;
  parameter AWIDTH = 10;

  reg clk = 0;
  reg en;
  reg [DWIDTH/8-1:0] wbe;
  reg [AWIDTH-1:0] addr;
  reg [DWIDTH-1:0] din;
  wire [DWIDTH-1:0] dout;

  dmem #(
      .DWIDTH(DWIDTH),
      .AWIDTH(AWIDTH)
  ) DMEM (
      .clk (clk),
      .en  (en),
      .wbe (wbe),
      .addr(addr),
      .din (din),
      .dout(dout)
  );

  always #5 clk = ~clk;

  integer num_mismatch = 0;

  initial begin
    $dumpfile("dmem_tb.fst");
    $dumpvars(0, dmem_tb);

    en  = 1'b1;
    wbe = 4'b0000;

    assert (DMEM.mem[0] == 0)
    else begin
      $error("Initial memory value is not 0");
      num_mismatch = num_mismatch + 1;
    end

    #1;
    wbe  = 4'b1111;
    addr = 0;
    din  = 32'hdeadbeef;

    @(posedge clk);
    #1;
    assert (DMEM.mem[0] == 32'hdeadbeef)
    else begin
      $error("Memory value is not 32'hdeadbeef");
      num_mismatch = num_mismatch + 1;
    end

    wbe  = 4'b0001;
    addr = 1;
    din  = 32'hcafebabe;

    @(posedge clk);
    #1;
    assert (DMEM.mem[1] == 32'h000000be)
    else begin
      $error("Memory value is not 32'h000000be");
      num_mismatch = num_mismatch + 1;
    end

    wbe  = 4'b0011;
    addr = 1;
    din  = 32'hffffffff;

    @(posedge clk);
    #1;
    assert (DMEM.mem[1] == 32'h0000ffff)
    else begin
      $error("Memory value is not 32'h0000ffff");
      num_mismatch = num_mismatch + 1;
    end

    wbe  = 4'b0000;
    addr = 0;

    assert (dout == 32'hdeadbeef)
    else begin
      $error("asynchronous read failed");
      num_mismatch = num_mismatch + 1;
    end

    #1;
    en = 1'b0;
    wbe = 4'b1111;
    addr = 0;
    din = 32'h00000000;

    @(posedge clk);
    #1;
    assert (DMEM.mem[0] == 32'hdeadbeef)
    else begin
      $error("Memory value is not 32'hdeadbeef");
      num_mismatch = num_mismatch + 1;
    end

    if (num_mismatch == 0)
      $display("All tests passed");
    else
      $display("%d tests failed", num_mismatch);

    $finish;
  end

endmodule
