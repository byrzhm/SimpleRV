module REGISTER (q, d, clk);
    parameter N = 1;
    output reg [N-1:0] q = {N{1'b0}};
    input [N-1:0] d;
    input clk;
    always @(posedge clk) q <= d;
endmodule

module REGISTER_R(q, d, clk, rst);
    parameter N = 1;
    parameter INIT = {N{1'b0}};
    output reg [N-1:0] q;
    input [N-1:0] d;
    input clk, rst;
    initial q = INIT;
    always @(posedge clk)
        if (rst) q <= INIT;
        else q <= d;
endmodule

module REGISTER_CE (q, d, clk, ce);
    parameter N = 1;
    parameter INIT = {N{1'b0}};
    output reg [N-1:0] q;
    input [N-1:0] d;
    input clk, ce;
    initial q = INIT;
    always @(posedge clk)
        if (ce) q <= d;
endmodule

module REGISTER_R_CE (q, d, clk, rst, ce);
    parameter N = 1;
    parameter INIT = {N{1'b0}};
    output reg [N-1:0] q;
    input [N-1:0] d;
    input clk, rst, ce;
    initial q = INIT;
    always @(posedge clk)
        if (rst) q <= {N{1'b0}};
        else if (ce) q <= d;
endmodule
