# This argument defines the simulator to be use
SIM ?= GHDL
# This argiment defines the language to be use
TOPLEVEL_LANG ?= vhdl

PWD=$(shell pwd)

# This arguments enable the waveform generaton
SIM_ARGS+=--wave=wave.ghw

# This arguments assign de generic value
SIM_ARGS+=-gData_Width=20
SIM_ARGS+=-gPolynomial_Order=9

ifeq ($(TOPLEVEL_LANG),vhdl)
    VHDL_SOURCES = $(PWD)/../par_scrambler.vhd
    # ifneq ($(filter $(SIM),ius xcelium),)
    #     COMPILE_ARGS += -v93
    # endif
else ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/../par_scrambler.sv
else
    $(error A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = par_scrambler

# MODULE is the basename of the Python test file
MODULE = test_par_scram

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
