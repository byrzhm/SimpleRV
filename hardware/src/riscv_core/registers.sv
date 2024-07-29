module REGISTER #(
    parameter N = 1
) (
    output reg [N-1:0] q,
    input [N-1:0] d,
    input clk
);
  initial q = {N{1'b0}};
  always @(posedge clk) q <= d;
endmodule

module REGISTER_R #(
    parameter N = 1,
    parameter INIT = {N{1'b0}}
) (
    output reg [N-1:0] q,
    input [N-1:0] d,
    input clk,
    input rst
);
  initial q = INIT;
  always @(posedge clk)
    if (rst) q <= INIT;
    else q <= d;
endmodule

module REGISTER_CE #(
    parameter N = 1,
    parameter INIT = {N{1'b0}}
) (
    output reg [N-1:0] q,
    input [N-1:0] d,
    input clk,
    input ce
);
  initial q = INIT;
  always @(posedge clk) if (ce) q <= d;
endmodule

module REGISTER_R_CE #(
    parameter N = 1,
    parameter INIT = {N{1'b0}}
) (
    output reg [N-1:0] q,
    input [N-1:0] d,
    input clk,
    input rst,
    input ce
);
  initial q = INIT;
  always @(posedge clk)
    if (rst) q <= {N{1'b0}};
    else if (ce) q <= d;
endmodule
