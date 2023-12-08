# This argument defines the simulator to be use
SIM ?= GHDL
# This argiment defines the language to be use
TOPLEVEL_LANG ?= vhdl

PWD=$(shell pwd)

# # Add VHDL version compatibility flag
# SIM_ARGS+=--std=08

# This arguments enable the waveform generaton
SIM_ARGS+=--wave=wave.ghw

# # This arguments assign de generic value

ifeq ($(TOPLEVEL_LANG),vhdl)
    # VHDL_SOURCES = $(PWD)/../../bit_rep/hdl/*.vhd
    # VHDL_SOURCES =+ $(PWD)/../../crc18/hdl/*.vhd
    # VHDL_SOURCES =+ $(PWD)/../../ln/hdl/*.vhd
    # VHDL_SOURCES =+ $(PWD)/../../scram/hdl/*.vhd
    # VHDL_SOURCES =+ $(PWD)/../hdl/sdi_tx_out.vhd
    VHDL_SOURCES = $(PWD)/../../*/hdl/*.vhd
else
    $(error A valid value (vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = sdi_tx_out

# MODULE is the basename of the Python test file
MODULE = test_sdi_tx_out

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim