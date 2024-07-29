SHELL                   := $(shell which bash) -o pipefail
ABS_TOP                 := $(shell pwd)
SCRIPTS                 := $(ABS_TOP)/scripts
VIVADO                  ?= vivado
VIVADO_OPTS             ?= -nolog -nojournal -mode batch
FPGA_PART               ?= xc7z020clg400-2
RTL                     += $(shell find $(ABS_TOP)/src -type f -name "*.v" -or -name "*.sv")
CONSTRAINTS             += $(shell find $(ABS_TOP)/src -type f -name "*.xdc")
TOP                     ?= top
SIM_RTL                 := $(shell find $(ABS_TOP)/sim -type f -name "*.sv")
SIM_MODELS              := $(shell find $(ABS_TOP)/sim_models -type f -name "*.v")
IVERILOG                := iverilog
IVERILOG_OPTS           := -Ttyp -g2012 -gassertions -Wall -Wno-timescale -D ABS_TOP=$(ABS_TOP) -I $(ABS_TOP)/src/riscv_core -I $(ABS_TOP)/sim
VVP                     := vvp

all: build/impl/$(TOP).bit

sim/%.tbi: sim/%.sv $(RTL)
	cd sim && $(IVERILOG) $(IVERILOG_OPTS) -o $*.tbi $*.sv $(RTL) $(SIM_MODELS)

sim/%.fst: sim/%.tbi
	cd sim && $(VVP) $*.tbi -fst |& tee $*.log

build/target.tcl: $(RTL) $(CONSTRAINTS)
	mkdir -p build
	truncate -s 0 $@
	echo "set ABS_TOP                        $(ABS_TOP)"    >> $@
	echo "set TOP                            $(TOP)"    >> $@
	echo "set FPGA_PART                      $(FPGA_PART)"  >> $@
	echo "set_param general.maxThreads       4"    >> $@
	echo "set_param general.maxBackupLogs    0"    >> $@
	echo -n "set RTL { " >> $@
	FLIST="$(RTL)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	echo "}" >> $@
	echo -n "set CONSTRAINTS { " >> $@
	FLIST="$(CONSTRAINTS)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	echo "}" >> $@

setup: build/target.tcl

elaborate: build/target.tcl $(SCRIPTS)/elaborate.tcl
	mkdir -p ./build
	cd ./build && $(VIVADO) $(VIVADO_OPTS) -source $(SCRIPTS)/elaborate.tcl |& tee elaborate.log

build/synth/$(TOP).dcp: build/target.tcl $(SCRIPTS)/synth.tcl
	mkdir -p ./build/synth/
	cd ./build/synth/ && $(VIVADO) $(VIVADO_OPTS) -source $(SCRIPTS)/synth.tcl |& tee synth.log

synth: build/synth/$(TOP).dcp

build/impl/$(TOP).bit: build/synth/$(TOP).dcp $(SCRIPTS)/impl.tcl
	mkdir -p ./build/impl/
	cd ./build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(SCRIPTS)/impl.tcl |& tee impl.log

impl: build/impl/$(TOP).bit

program: build/impl/$(TOP).bit $(SCRIPTS)/program.tcl
	cd build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(SCRIPTS)/program.tcl

program-force:
	cd build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(SCRIPTS)/program.tcl

vivado: build
	cd build && nohup $(VIVADO) </dev/null >/dev/null 2>&1 &

lint:
	verilator -DABS_TOP=$(ABS_TOP) --lint-only --top-module $(TOP) $(RTL) -I$(ABS_TOP)/src/riscv_core $(ABS_TOP)/stubs/PLLE2_ADV.v $(ABS_TOP)/sim_models/BUFG.v $(ABS_TOP)/stubs/IBUF.v

screen:
	screen /dev/ttyUSB0 115200

clean-sim:
	rm -rf *.daidir sim/output.txt \
	sim/*.tb sim/*.daidir sim/csrc \
	sim/ucli.key sim/*.vpd sim/*.vcd \
	sim/*.tbi sim/*.fst sim/*.jou sim/*.log sim/*.out \
	sim/isa sim/c_tests sim/small

clean-build:
	rm -rf ./build

.PHONY: setup synth impl program program-force vivado all clean-build clean-sim all
.PRECIOUS: sim/%.tb sim/%.tbi sim/%.fst sim/%.vpd
