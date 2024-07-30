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
