import sys
sys.path.insert(0, '../../../../src/misc/scram/model')
from nrz_2_nrzi_model import nrz_2_nrzi_bit

import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


CLK_PERIOD = 13.47  # ns (74.25 MHz)
DATA_W = 10


async def init_test(dut):
    dut.rst.value = 1
    dut.clk_en.value = 1
    dut.nrzi_en.value = 0
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
async def nrzi_basic_test(dut):

    input_bits = 0b1010101010
    input_vec = binary_number_to_array(input_bits)
    output_bit = nrz_2_nrzi_bit(input_vec)
    print(output_bit[-9:])

    await init_test(dut)
    dut.d_p_nrzi.value = 0
    await ClockCycles(dut.clk, 1)

    dut.data_i.value = int(input_bits)
    dut.nrzi_en.value = 1
    await ClockCycles(dut.clk, 2)
    print(binary_number_to_array(dut.data_o.value)[:9])

    assert binary_number_to_array(dut.data_o.value)[:9] == output_bit[-9:], \
        f"NRZ to NRZI consersion result is incorrect: {binary_number_to_array(dut.data_o.value)[:9]} != {output_bit[-9:]}"
