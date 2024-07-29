`timescale 1ns / 1ns
`include "../src/riscv_core/control_signals.vh"

module stx_tb ();

  reg  [31:0] din;
  reg  [ 1:0] byte_offset;
  reg  [ 1:0] st_sel;
  wire [31:0] dout;
  wire [ 3:0] wbe;

  stx STX (
      .din(din),
      .byte_offset(byte_offset),
      .st_sel(st_sel),
      .dout(dout),
      .wbe(wbe)
  );

  integer num_mismatch = 0;
  integer test_num = 0;

  initial begin
    $dumpfile("stx_tb.fst");
    $dumpvars(0, stx_tb);

    din = 32'h12345678;

    // store word
    byte_offset = 2'd0;
    st_sel = `ST_WORD;

    #1;
    assert (dout === 32'h12345678 && wbe === 4'b1111)
    else begin
      $error("Test %0d failed! dout expected %h, got %h; wbe expected %b, got %b", test_num,
             32'h12345678, dout, 4'b1111, wbe);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;


    // store half word
    byte_offset = 2'd0;
    st_sel = `ST_HALF;

    #1;
    assert (dout === 32'h12345678 && wbe === 4'b0011)
    else begin
      $error("Test %0d failed! dout expected %h, got %h; wbe expected %b, got %b", test_num,
             32'h12345678, dout, 4'b0011, wbe);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;


    byte_offset = 2'd2;
    st_sel = `ST_HALF;

    #1;
    assert (dout === 32'h56780000 && wbe === 4'b1100)
    else begin
      $error("Test %0d failed! dout expected %h, got %h; wbe expected %b, got %b", test_num,
             32'h56780000, dout, 4'b1100, wbe);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;


    // store byte
    byte_offset = 2'd0;
    st_sel = `ST_BYTE;

    #1;
    assert (dout === 32'h12345678 && wbe === 4'b0001)
    else begin
      $error("Test %0d failed! dout expected %h, got %h; wbe expected %b, got %b", test_num,
             32'h12345678, dout, 4'b0001, wbe);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;


    byte_offset = 2'd1;
    st_sel = `ST_BYTE;

    #1;
    assert (dout === 32'h34567800 && wbe === 4'b0010)
    else begin
      $error("Test %0d failed! dout expected %h, got %h; wbe expected %b, got %b", test_num,
             32'h34567800, dout, 4'b0010, wbe);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'd2;
    st_sel = `ST_BYTE;

    #1;
    assert (dout === 32'h56780000 && wbe === 4'b0100)
    else begin
      $error("Test %0d failed! dout expected %h, got %h; wbe expected %b, got %b", test_num,
             32'h56780000, dout, 4'b0100, wbe);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;


    byte_offset = 2'd3;
    st_sel = `ST_BYTE;

    #1;
    assert (dout === 32'h78000000 && wbe === 4'b1000)
    else begin
      $error("Test %0d failed! dout expected %h, got %h; wbe expected %b, got %b", test_num,
             32'h78000000, dout, 4'b1000, wbe);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    if (num_mismatch == 0) begin
      $display("All tests passed!");
    end else begin
      $display("%0d tests failed!", num_mismatch);
    end
  end

endmodule
