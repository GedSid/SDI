# import cocotb
# from cocotb.triggers import ClockCycles
# from cocotb.clock import Clock
# from cocotb.regression import TestFactory
# from random import getrandbits
# import pytest



# # @cocotb.test()
# async def test_sdi_bit_rep(dut):
#   await init(dut)
#   N = 10
#   for _ in range(10):
#     # data_i = [cocotb.randbit() for _ in range(10)]
#     data_i = [getrandbits(len(dut.data_i)) for _ in range(N)]
#     dut.data_i <= data_i

#     dut.clk_en <= '1'
#     await ClockCycles(dut.clk, 1)

#     # cocotb.log(f"Test {i+1}: Input = {data_i}, Output = {dut.data_o}")
#     print(data_i)
#     print(dut.data_o)

# tf = TestFactory(test_sdi_bit_rep, "sdi_bit_rep")
# tf.generate_tests()

# # if __name__ == '__main__':
# #   test()

import os
import random
import sys
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

# if cocotb.simulator.is_running():
#     from sdi_bit_rep_model import sdi_bit_rep_model

async def init(dut):
    cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    
    dut.clk_en.value = 0
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    await ClockCycles(dut.clk, 10)

@cocotb.test()
async def sdi_bit_rep_basic_test(dut):
    await init(dut)

    # Perform some test cases
    for _ in range(1):
        # Randomize input data
        data_i = random.getrandbits(len(dut.data_i))
        # print(data_i)
        dut.data_i.value = data_i

        # Set clk_en to 1 for every clock cycle
        dut.clk_en.value = 1

        # Wait for a rising edge
        await ClockCycles(dut.clk, 1)

        # Perform your own verification here if needed
        data_o = dut.data_o.value
        print(data_o)

        await ClockCycles(dut.clk, 1)
        data_o = dut.data_o.value
        print(data_o)
        # expected_output = sdi_bit_rep_model(data_i)
        # assert data_o == expected_output, f"Test {i+1} failed"

# @cocotb.test()
# async def sdi_bit_rep_randomised_test(dut):
#     """Randomized test for the sdi_bit_rep module"""

#     for i in range(10):
#         # Randomize input data
#         data_i = [random.randint(0, 1) for _ in range(10)]
# data_i = [random.getrandbits(len(dut.data_i)) for _ in range(2)]
#         dut.data_i <= data_i

#         # Set clk_en to 1 for every clock cycle
#         dut.clk_en <= '1'

#         # Wait for a rising edge
#         await RisingEdge(dut.clk)

#         # Perform your own verification here if needed
#         # expected_output = sdi_bit_rep_model(data_i)
#         # assert dut.data_o == expected_output, f"Randomized test {i+1} failed"


def test_sdi_bit_rep_runner():
    # hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    # sim = os.getenv("SIM", "icarus")
    sim = os.getenv("SIM", "ghdl")

    proj_path = Path(__file__).resolve().parent.parent
    # equivalent to setting the PYTHONPATH environment variable
    sys.path.append(str(proj_path / "model"))

    vhdl_sources = []
    vhdl_sources = [proj_path / "hdl" / "sdi_bit_rep.vhd"]

    sys.path.append(str(proj_path / "tests"))
    runner = get_runner(sim)
    runner.build(
        vhdl_sources = vhdl_sources,
        hdl_toplevel = "sdi_bit_rep",
        always = True,
    )
    runner.test(hdl_toplevel="sdi_bit_rep", test_module="test_sdi_bit_rep")

if __name__ == "__main__":
    test_sdi_bit_rep_runner()
