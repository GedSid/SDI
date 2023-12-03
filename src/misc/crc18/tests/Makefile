# This argument defines the simulator to be use
SIM ?= GHDL
# This argiment defines the language to be use
TOPLEVEL_LANG ?= vhdl

PWD=$(shell pwd)

# This arguments enable the waveform generaton
SIM_ARGS+=--wave=wave.ghw

# # This arguments assign de generic value

ifeq ($(TOPLEVEL_LANG),vhdl)
    VHDL_SOURCES = $(PWD)/../hdl/crc18.vhd
else
    $(error A valid value (vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = crc18

# MODULE is the basename of the Python test file
MODULE = test_crc18

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim