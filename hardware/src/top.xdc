##LEDs

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {FPGA_LEDS[0]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {FPGA_LEDS[1]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {FPGA_LEDS[2]}]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {FPGA_LEDS[3]}]

##Buttons

set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {FPGA_BUTTONS[0]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports {FPGA_BUTTONS[1]}]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {FPGA_BUTTONS[2]}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports {FPGA_BUTTONS[3]}]

## Clock signal 125 MHz

set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports CLK_50MHZ_FPGA]
create_clock -period 20.000 -name CLK_50MHZ_FPGA -waveform {0.000 10.000} -add [get_ports CLK_50MHZ_FPGA]

#set_property -dict {PACKAGE_PIN XXX IOSTANDARD LVCMOS33} [get_ports CTS]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports FPGA_SERIAL_TX]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports FPGA_SERIAL_RX]
#set_property -dict {PACKAGE_PIN XXX IOSTANDARD LVCMOS33} [get_ports RTS]
