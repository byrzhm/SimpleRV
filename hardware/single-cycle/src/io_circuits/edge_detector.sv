module edge_detector #(
    parameter WIDTH = 1
) (
    input clk,
    input [WIDTH-1:0] signal_in,
    output [WIDTH-1:0] edge_detect_pulse
);
  wire [WIDTH-1:0] dff0_q;
  REGISTER #(
      .N(WIDTH)
  ) dff0 (
      .q  (dff0_q),
      .d  (signal_in),
      .clk(clk)
  );

  wire [WIDTH-1:0] dff1_q;
  REGISTER #(
      .N(WIDTH)
  ) dff1 (
      .q  (dff1_q),
      .d  (dff0_q),
      .clk(clk)
  );

  wire [WIDTH-1:0] dff2_q;
  REGISTER #(
      .N(WIDTH)
  ) dff2 (
      .q  (dff2_q),
      .d  (dff1_q),
      .clk(clk)
  );

  assign edge_detect_pulse = dff2_q & ~dff1_q;

endmodule
