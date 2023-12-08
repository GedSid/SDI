import sys
sys.path.insert(0, '../../../src/crc18/model')
from crc18_model import crc18_model

import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


CLK_PERIOD = 13.47  # ns (74.25 MHz)
DATA_W = 10


async def init_test(dut):
    dut.rst.value = 1
    dut.clk_en.value = 1
    dut.crc_en.value = 0
    dut.crc_clr.value = 1
    start_soon(Clock(dut.clk, CLK_PERIOD, 'ns').start())
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    await ClockCycles(dut.clk, 10)


def binary_number_to_array(binary_number):
    binary_string = bin(binary_number)
    binary_string = binary_string[2:]
    binary_array = [int(bit) for bit in binary_string]
    return binary_array


@cocotb.test()
async def crc18_test(dut):

    model = crc18_model()

    input_bits = 0b1110111011

    input_vec = binary_number_to_array(input_bits)

    model.update_crc(input_vec, 1, 1)

    await init_test(dut)
    await ClockCycles(dut.clk, 1)

    dut.crc_clr.value = 0

    await ClockCycles(dut.clk, 1)

    dut.data_i.value = int(input_bits)
    dut.crc_en.value = 1

    await ClockCycles(dut.clk, 2)
    assert binary_number_to_array(dut.crc_o.value) == model.get_crc_output()
    await ClockCycles(dut.clk, 6)
