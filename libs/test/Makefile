# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

# defaults
SIM ?= GHDL
TOPLEVEL_LANG ?= vhdl

# This arguments enable the waveform generaton
SIM_ARGS+=--wave=wave.ghw

# This arguments asign de generic value
SIM_ARGS+=-gData_Width=20
SIM_ARGS+=-gPolynomial_Order=9

VHDL_SOURCES += $(PWD)/../par_scrambler.vhd
# use VHDL_SOURCES for VHDL files
# use VERILOG_SOURCES for VERILOG files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = par_scrambler

# MODULE is the basename of the Python test file
MODULE = test_par_scrambler

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
