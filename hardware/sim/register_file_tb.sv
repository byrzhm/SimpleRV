`timescale 1ns / 1ns

module register_file_tb ();

  reg clk = 0;
  reg we;
  reg [4:0] addr1, addr2, addr3;
  reg [31:0] data3;
  wire [31:0] data1, data2;

  // dut
  register_file rf (
      .clk(clk),
      .we(we),
      .addr1(addr1),
      .addr2(addr2),
      .addr3(addr3),
      .data3(data3),
      .data1(data1),
      .data2(data2)
  );

  always #5 clk = ~clk;

  initial begin

    $dumpfile("register_file_tb.fst");
    $dumpvars(0, register_file_tb);

    we = 0;
    addr1 = 0;
    addr2 = 0;
    addr3 = 0;
    data3 = 0;

    repeat (2) @(posedge clk);

    if (data1 !== 32'h0 || data2 !== 32'h0)
      $error("data1 expected 0, got %h; data2 expected 0, got %h", data1, data2);

    we = 1;
    addr3 = 5;
    addr1 = 5;
    data3 = 32'hdeadbeef;

    @(posedge clk);
    #1;
    if (data1 !== 32'hdeadbeef) $error("data1 expected deadbeef, got %h", data1);

    we = 0;
    addr2 = 5;
    // asynchroneous read, should immediately read the new value
    if (data2 !== 32'hdeadbeef) $error("data2 expected deadbeef, got %h", data2);

    we = 1;
    addr1 = 0;
    addr3 = 0;
    data3 = 32'hffffffff;

    @(posedge clk);
    #1;
    if (data1 !== 32'h00000000) $error("x0 is wired to 0, data1 expected 00000000, got %h", data1);

    $display("Testbench passed");
    $finish;
  end

endmodule
