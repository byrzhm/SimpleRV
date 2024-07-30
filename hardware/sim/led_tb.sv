`timescale 1ns / 1ns
`include "../src/riscv_core/opcode.vh"

module led_tb ();
  reg clk, rst;
  wire [3:0] leds;
  parameter CPU_CLOCK_PERIOD = 20;
  parameter CPU_CLOCK_FREQ = 1_000_000_000 / CPU_CLOCK_PERIOD;
  localparam BAUD_RATE = 10_000_000;
  localparam BAUD_PERIOD = 1_000_000_000 / BAUD_RATE;  // 8680.55 ns

  localparam TIMEOUT_CYCLE = 100_000;

  initial clk = 0;
  always #(CPU_CLOCK_PERIOD / 2) clk = ~clk;

  cpu #(
      .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ),
      .RESET_PC(32'h1000_0000),
      .BAUD_RATE(BAUD_RATE),
      .PROG_MIF_HEX("../../software/led/led.hex")
  ) cpu (
      .clk(clk),
      .rst(rst),
      .leds(leds),
      .serial_in(1'b1),  // input
      .serial_out()  // output
  );

  integer i, j;
  reg [31:0] cycle;
  always @(posedge clk) begin
    if (rst === 1) cycle <= 0;
    else cycle <= cycle + 1;
  end


  reg [63:0] test_status;
  reg [31:0] num_failed_tests = 0;

  task wait_for_leds;
    input [3:0] target_leds;
    begin
      while (leds !== target_leds) begin
        @(posedge clk);
      end
      $display("LEDs reached target %h at cycle %d", target_leds, cycle);
    end
  endtask

  task check_leds;
    input [3:0] prev_leds;
    input [3:0] expected_leds;
    begin
      while (leds === prev_leds) begin
        @(posedge clk);
      end

      if (leds !== expected_leds) begin
        $display("Test failed at cycle %d. Expected: %h, Actual: %h", cycle, expected_leds, leds);
        num_failed_tests = num_failed_tests + 1;
      end else begin
        $display("Test passed at cycle %d. Expected: %h, Actual: %h", cycle, expected_leds, leds);
      end

    end
  endtask

  initial begin
    $dumpfile("led_tb.fst");
    $dumpvars(0, led_tb);

    rst = 1;

    // Hold reset for a while
    repeat (10) @(posedge clk);

    @(negedge clk);
    rst = 0;

    assert (leds === 4'b0000)
    else begin
      $display("Test failed at cycle %d. Expected: %h, Actual: %h", cycle, 4'b0000, leds);
      num_failed_tests = num_failed_tests + 1;
    end

    wait_for_leds(4'b0001);
    repeat (4) begin
      check_leds(4'b0001, 4'b0010);
      check_leds(4'b0010, 4'b0100);
      check_leds(4'b0100, 4'b1000);
      check_leds(4'b1000, 4'b0001);
    end
    $finish;
  end

  initial begin
    repeat (TIMEOUT_CYCLE) @(posedge clk);
    $display("Timeout!");
    $fatal();
  end

endmodule
