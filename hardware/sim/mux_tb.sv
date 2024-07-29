`timescale 1ns / 1ns

module mux_tb ();

  parameter DWIDTH = 32;

  reg sel2to1;
  reg [1:0] sel4to1;
  reg [DWIDTH-1:0] in0, in1, in2, in3;
  wire [DWIDTH-1:0] out2to1, out4to1;

  // dut
  mux2to1 #(
      .DWIDTH(DWIDTH)
  ) MUX2TO1 (
      .in0(in0),
      .in1(in1),
      .sel(sel2to1),
      .out(out2to1)
  );

  mux4to1 #(
      .DWIDTH(DWIDTH)
  ) MUX4TO1 (
      .in0(in0),
      .in1(in1),
      .in2(in2),
      .in3(in3),
      .sel(sel4to1),
      .out(out4to1)
  );

  integer num_mismatch = 0;

  initial begin

    // test mux2to1
    in0 = 32'h00000000;
    in1 = 32'h00000001;
    sel2to1 = 0;
    #1;
    assert (out2to1 === 32'h00000000)
    else begin
      $error("MUX2TO1 failed: expected %h, got %h", 32'h00000000, out2to1);
      num_mismatch = num_mismatch + 1;
    end

    sel2to1 = 1;
    #1;
    assert (out2to1 === 32'h00000001)
    else begin
      $error("MUX2TO1 failed: expected %h, got %h", 32'h00000001, out2to1);
      num_mismatch = num_mismatch + 1;
    end

    // test mux4to1
    in0 = 32'h00000000;
    in1 = 32'h00000001;
    in2 = 32'h00000010;
    in3 = 32'h00000011;
    sel4to1 = 2'b00;
    #1;
    assert (out4to1 === 32'h00000000)
    else begin
      $error("MUX4TO1 failed: expected %h, got %h", 32'h00000000, out4to1);
      num_mismatch = num_mismatch + 1;
    end

    sel4to1 = 2'b01;
    #1;
    assert (out4to1 === 32'h00000001)
    else begin
      $error("MUX4TO1 failed: expected %h, got %h", 32'h00000001, out4to1);
      num_mismatch = num_mismatch + 1;
    end

    sel4to1 = 2'b10;
    #1;
    assert (out4to1 === 32'h00000010)
    else begin
      $error("MUX4TO1 failed: expected %h, got %h", 32'h00000010, out4to1);
      num_mismatch = num_mismatch + 1;
    end

    sel4to1 = 2'b11;
    #1;
    assert (out4to1 === 32'h00000011)
    else begin
      $error("MUX4TO1 failed: expected %h, got %h", 32'h00000011, out4to1);
      num_mismatch = num_mismatch + 1;
    end

    if (num_mismatch == 0) begin
      $display("All tests pass");
    end else begin
      $display("%d tests failed", num_mismatch);
    end

  end


endmodule
