ABS_TOP                 := $(shell pwd)
RTL                     += $(shell find $(ABS_TOP)/src -type f -name "*.sv" -or -name "*.vh")
TOP                     ?= top

SIM_RTL                 := $(shell find sim -type f -name "*.sv")
IVERILOG                := iverilog
IVERILOG_OPTS           := -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale
IVERILOG_TARGETS        := $(SIM_RTL:%.sv=%.fst)
VVP                     := vvp

sim/%.tbi: sim/%.sv $(RTL)
	cd sim && $(IVERILOG) $(IVERILOG_OPTS) -o $*.tbi $*.sv $(RTL)

$(IVERILOG_TARGETS): sim/%.fst: sim/%.tbi
	cd sim && $(VVP) $*.tbi -fst

lint:
	verilator --lint-only --top-module $(TOP) $(RTL)

echo:
	@echo $(RTL)
	@echo $(SIM_RTL)
	@echo $(IVERILOG_TARGETS)

clean:
	rm -rf sim/*.vcd sim/*.tbi sim/*.fst sim/*.out

.PHONY: clean
.PRECIOUS: sim/%.tbi sim/%.fst
