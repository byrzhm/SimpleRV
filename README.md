# Simple RISC-V Chips

This is a single-cycle implementation of RV32I.

## FPGA Verification

**test program**

```c
#define HOLD_CYCLE 200000 // small for simulation, large for real board
#define FPGA_LED (*((volatile unsigned int *)0x80000020))

int main() {
  for (;;) {
    FPGA_LED = 0x01;
    for (int i = 0; i < HOLD_CYCLE; i++)
      ;
    FPGA_LED = 0x02;
    for (int i = 0; i < HOLD_CYCLE; i++)
      ;
    FPGA_LED = 0x04;
    for (int i = 0; i < HOLD_CYCLE; i++)
      ;
    FPGA_LED = 0x08;
    for (int i = 0; i < HOLD_CYCLE; i++)
      ;
  }
  return 0;
}
```

### Alinx AX7020

![Alinx AX7020](https://www.alinx.com/upload/image/20220823/AX7020.jpg)

> [!CAUTION]
> The buttons and leds are *active low* in Alinx AX7020 board, so you need to invert output leds and input buttons in top module.

#### invert leds

``` verilog
  // LEDs
  wire [3:0] leds;
  assign FPGA_LEDS = ~leds; // active low

  //...

  cpu #(
      .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ),
      .RESET_PC(RESET_PC),
      .BAUD_RATE(BAUD_RATE),
      .PROG_MIF_HEX(PROG_MIF_HEX)
  ) cpu (
      .clk(cpu_clk),
      .rst(cpu_reset),
      .leds(leds),
      .serial_out(cpu_tx),
      .serial_in(cpu_rx)
  );
```

#### invert buttons

``` verilog
  button_parser #(
      .WIDTH(4),
      .SAMPLE_CNT_MAX(B_SAMPLE_CNT_MAX),
      .PULSE_CNT_MAX(B_PULSE_CNT_MAX)
  ) bp (
      .clk(cpu_clk),
      .in (~FPGA_BUTTONS), // active low
      .out(buttons_pressed)
  );
```

https://github.com/user-attachments/assets/ee57e0df-fc14-4283-ae6c-762fa20b9fd6

### DE10-Standard

![DE10-Standard](https://www.terasic.com.tw/attachment/archive/1105/image/45degree.jpg)

> [!NOTE]
> DE10-Standard board's leds and buttons are active high, so you don't need to invert those signals.

https://github.com/user-attachments/assets/d60a96e2-cb31-4924-92dd-a46ed77d2210
