# import sys
# sys.path.insert(0, '../../../../src/crc18/model')
# from crc18_model import crc18_smpte_model


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
    dut.crc_clr.value = 0
    start_soon(Clock(dut.clk, CLK_PERIOD, 'ns').start())
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    dut.crc_en.value = 1
    dut.crc_clr.value = 1
    await ClockCycles(dut.clk, 10)


def binary_number_to_array(binary_number):
    binary_string = bin(binary_number)
    binary_string = binary_string[2:]
    binary_array = [int(bit) for bit in binary_string]
    return binary_array


@cocotb.test()
async def crc_basic_test(dut):

    model = crc18_smpte_model()

    input_bits = 0b1010101010
    input_vec = binary_number_to_array(input_bits)
    print(input_vec)
    model.update_crc(input_vec, dut.crc_clr.value, dut.crc_en.value)
    output_bit = model.get_crc_output()
    print(output_bit)

    await init_test(dut)
    print("test 3")

    dut.data_i.value = int(input_bits)
    dut.crc_en.value = 1
    await ClockCycles(dut.clk, 2)
    print(binary_number_to_array(dut.data_o.value))

    assert binary_number_to_array(dut.data_o.value)[:9] == output_bit[-9:], f"CRC consersion result is incorrect: {binary_number_to_array(dut.data_o.value)[:9]} != {output_bit[-9:]}"
