module registers_tb ();

  parameter N = 32;

  reg rst, ce, clk;
  reg [N-1:0] d;
  wire [N-1:0] q, q_r, q_ce, q_r_ce;

  // dut
  REGISTER #(
      .N(N)
  ) register (
      .q,
      .d,
      .clk
  );
  REGISTER_CE #(
      .N(N)
  ) register_ce (
      .q(q_ce),
      .d,
      .ce,
      .clk
  );
  REGISTER_R #(
      .N(N)
  ) register_r (
      .q(q_r),
      .d,
      .rst,
      .clk
  );
  REGISTER_R_CE #(
      .N(N)
  ) register_r_ce (
      .q(q_r_ce),
      .d,
      .rst,
      .ce,
      .clk
  );

  initial begin

    $dumpfile("registers_tb.fst");
    $dumpvars(0, registers_tb);

    clk = 0;
    rst = 1;
    ce  = 0;
    d   = 0;

    repeat (2) @(posedge clk);
    rst = 0;

    if (q !== 32'h0 || q_r !== 32'h0 || q_ce !== 32'h0 || q_r_ce !== 32'h0)
      $error("[time %t]: q = %h, q_r = %h, q_ce = %h, q_r_ce = %h", $time, q, q_r, q_ce, q_r_ce);

    d = 32'hdeadbeef;  // register and register_r should update to 32'hdeadbeef

    @(posedge clk);
    #1;
    if (q !== 32'hdeadbeef) $error("[time %t]: q = %h", $time, q);
    if (q_r !== 32'hdeadbeef) $error("[time %t]: q_r = %h", $time, q_r);

    ce = 1;  // register_ce and register_r_ce should update to 32'hdeadbeef

    @(posedge clk);
    #1;
    if (q_ce !== 32'hdeadbeef) $error("[time %t]: q_ce = %h", $time, q_ce);
    if (q_r_ce !== 32'hdeadbeef) $error("[time %t]: q_r_ce = %h", $time, q_r_ce);

    ce = 0;
    d  = 32'hcafebabe;  // register and register_r should update to 32'hcafebabe
    // register_ce and register_r_ce should not update

    @(posedge clk);
    #1;
    if (q !== 32'hcafebabe) $error("[time %t]: q = %h", $time, q);
    if (q_r !== 32'hcafebabe) $error("[time %t]: q_r = %h", $time, q_r);
    if (q_ce !== 32'hdeadbeef) $error("[time %t]: q_ce = %h", $time, q_ce);
    if (q_r_ce !== 32'hdeadbeef) $error("[time %t]: q_r_ce = %h", $time, q_r_ce);

    #1;
    $error("Testbench passed");
    $finish;
  end

  always #5 clk = ~clk;

endmodule
