module top (
    input  CLK,                   // system clock 
    input  RESET,                 // reset button
    output [3:0] LEDS,            // system LEDs
    input  FPGA_SERIAL_RX,        // UART receive
    output FPGA_SERIAL_TX         // UART transmit
);
    wire core_clk = CLK;
    wire core_rst = RESET;
    core CORE (
        .clk(core_clk),
        .rst(core_rst)
    );

endmodule