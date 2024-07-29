`timescale 1ns / 1ns
`include "../src/riscv_core/control_signals.vh"

module ldx_tb ();

  reg [31:0] in;
  reg [2:0] ld_sel;
  reg [1:0] byte_offset;
  wire [31:0] out;

  ldx LDX (
      .in(in),
      .ld_sel(ld_sel),
      .byte_offset(byte_offset),
      .out(out)
  );

  integer num_mismatch = 0;
  integer test_num = 0;

  initial begin
    $dumpfile("ldx_tb.fst");
    $dumpvars(0, ldx_tb);

    in = 32'hdeadbeef;

    // load word
    byte_offset = 2'b00;
    ld_sel = `LD_WORD;

    #1;
    assert (out === 32'hdeadbeef)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'hdeadbeef, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;


    // load half word
    byte_offset = 2'b00;
    ld_sel = `LD_HALF;

    #1;
    assert (out === 32'hffffbeef)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'hffffbeef, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'b10;
    ld_sel = `LD_HALF;

    #1;
    assert (out === 32'hffffdead)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'hffffdead, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    // load half word unsigned
    byte_offset = 2'b00;
    ld_sel = `LD_HALF_UN;

    #1;
    assert (out === 32'h0000beef)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'h0000beef, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;


    byte_offset = 2'b10;
    ld_sel = `LD_HALF_UN;

    #1;
    assert (out === 32'h0000dead)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'h0000dead, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    // load byte
    byte_offset = 2'b00;
    ld_sel = `LD_BYTE;

    #1;
    assert (out === 32'hffffffef)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'hffffffef, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'b01;
    ld_sel = `LD_BYTE;

    #1;
    assert (out === 32'hffffffbe)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'hffffffbe, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'b10;
    ld_sel = `LD_BYTE;

    #1;
    assert (out === 32'hffffffad)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'hffffffad, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'b11;
    ld_sel = `LD_BYTE;

    #1;
    assert (out === 32'hffffffde)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'hffffffde, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    // load byte unsigned
    byte_offset = 2'b00;
    ld_sel = `LD_BYTE_UN;

    #1;
    assert (out === 32'h000000ef)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'h000000ef, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'b01;
    ld_sel = `LD_BYTE_UN;

    #1;
    assert (out === 32'h000000be)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'h000000be, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'b10;
    ld_sel = `LD_BYTE_UN;

    #1;
    assert (out === 32'h000000ad)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'h000000ad, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    byte_offset = 2'b11;
    ld_sel = `LD_BYTE_UN;

    #1;
    assert (out === 32'h000000de)
    else begin
      $error("Test %0d failed! Expect %h, got %h", test_num, 32'h000000de, out);
      num_mismatch = num_mismatch + 1;
    end
    test_num = test_num + 1;

    if (num_mismatch == 0) $display("All tests passed");
    else $display("%d tests failed", num_mismatch);

    $finish;
  end

endmodule
