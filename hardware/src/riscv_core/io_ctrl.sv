module io_ctrl #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 10
) (
    input clk,
    input rst,
    input en,
    input [AWIDTH-1:0] addr,
    input [DWIDTH-1:0] din,
    input [DWIDTH/8-1:0] wbe,
    output reg [DWIDTH-1:0] dout,

    // IO Ports
    output [3:0] leds,
    input serial_in,
    output serial_out
);

  // TODO: UART
  assign serial_out = 1'b1;

  // TODO: Counters

  // LEDs
  wire led_reg_ce;
  REGISTER_R_CE #(
      .N(4),
      .INIT(4'b0000)
  ) led_reg (
      .q  (leds),
      .d  (din[3:0]),
      .clk(clk),
      .rst(rst),
      .ce (led_reg_ce)
  );
  assign led_reg_ce = en & (addr == 4'b1000) & wbe[0];
    // assign leds = 4'b1110; // debug
  

  // TODO: Read logic
  // always @(*) begin
  //   dout = ...;
  // end

endmodule
