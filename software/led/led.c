#define TIME     1000000
#define FPGA_LED (*((volatile unsigned int *)0x80000020))

int main() {
  for (;;) {
    FPGA_LED = 0x01;
    for (int i = 0; i < TIME; i++)
      ;
    FPGA_LED = 0x02;
    for (int i = 0; i < TIME; i++)
      ;
    FPGA_LED = 0x04;
    for (int i = 0; i < TIME; i++)
      ;
    FPGA_LED = 0x08;
    for (int i = 0; i < TIME; i++)
      ;
  }
  return 0;
}