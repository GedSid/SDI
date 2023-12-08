# This argument defines the simulator to be use
SIM ?= GHDL
# This argiment defines the language to be use
TOPLEVEL_LANG ?= vhdl

PWD=$(shell pwd)

# This arguments enable the waveform generaton
SIM_ARGS+=--wave=wave.ghw

# # This arguments assign de generic value

ifeq ($(TOPLEVEL_LANG),vhdl)
    VHDL_SOURCES = $(PWD)/../hdl/nrz_2_nrzi.vhd
else
    $(error A valid value (vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = nrz_2_nrzi

# MODULE is the basename of the Python test file
MODULE = test_nrz_2_nrzi

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim