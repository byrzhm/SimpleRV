`timescale 1ns / 1ns

module comparator_tb ();

  parameter DWIDTH = 32;

  reg [DWIDTH-1:0] a, b;
  reg br_un;
  wire br_eq, br_lt;

  comparator #(
      .DWIDTH(DWIDTH)
  ) COMP (
      .a(a),
      .b(b),
      .br_un(br_un),
      .br_eq(br_eq),
      .br_lt(br_lt)
  );

  integer num_mismatches = 0;

  initial begin
    $dumpfile("comparator_tb.fst");
    $dumpvars(0, comparator_tb);

    // Test unsigned comparison
    a = 32'h00000000;
    b = 32'h00000000;
    br_un = 1;
    #1;
    if (br_eq !== 1) begin
      $error("unsigned comparison failed: br_eq expected 1, got %h", br_eq);
      num_mismatches = num_mismatches + 1;
    end
    if (br_lt !== 0) begin
      $error("unsigned comparison failed: br_lt expected 0, got %h", br_lt);
      num_mismatches = num_mismatches + 1;
    end

    a = 32'h00000000;
    b = 32'h00000001;
    br_un = 1;
    #1;
    if (br_eq !== 0) begin
      $error("unsigned comparison failed: br_eq expected 0, got %h", br_eq);
      num_mismatches = num_mismatches + 1;
    end
    if (br_lt !== 1) begin
      $error("unsigned comparison failed: br_lt expected 1, got %h", br_lt);
      num_mismatches = num_mismatches + 1;
    end

    a = 32'h00000001;
    b = 32'h00000000;
    br_un = 1;
    #1;
    if (br_eq !== 0) begin
      $error("unsigned comparison failed: br_eq expected 0, got %h", br_eq);
      num_mismatches = num_mismatches + 1;
    end
    if (br_lt !== 0) begin
      $error("unsigned comparison failed: br_lt expected 0, got %h", br_lt);
      num_mismatches = num_mismatches + 1;
    end

    a = 32'h00000000;
    b = 32'h00000000;
    br_un = 0;
    #1;
    if (br_lt !== 0) begin
      $error("signed comparison failed: expected 0, got %h", br_lt);
      num_mismatches = num_mismatches + 1;
    end

    a = 32'h00000000;
    b = 32'h00000001;
    br_un = 0;
    #1;
    if (br_lt !== 1) begin
      $error("signed comparison failed: expected 1, got %h", br_lt);
      num_mismatches = num_mismatches + 1;
    end

    a = 32'hffffffff;
    b = 32'h00000001;
    br_un = 0;
    #1;
    if (br_lt !== 1) begin
      $error("signed comparison failed: expected 1, got %h", br_lt);
      num_mismatches = num_mismatches + 1;
    end

    a = 32'h00000001;
    b = 32'hffffffff;
    br_un = 0;
    #1;
    if (br_lt !== 0) begin
      $error("signed comparison failed: expected 0, got %h", br_lt);
      num_mismatches = num_mismatches + 1;
    end

    if (num_mismatches === 0) $display("All tests passed");
    else $display("%d tests failed", num_mismatches);

    $finish;
  end

endmodule
