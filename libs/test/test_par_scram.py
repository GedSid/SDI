import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge  # , Timer
# from cocotb.result import TestFailure
from random import getrandbits
# from operator import xor

CLK_PERIOD = 20  # ns
DATA_W = 20
POLY_ORDER = 9  # Se podria remplazar por el orden del polinomio
POLY = 0b1000010001
# FPOLY = [9, 4]


async def init_test(dut):

    dut.rst.value = 1
    dut.scram_rst.value = 0
    dut.scram_en.value = 0
    start_soon(Clock(dut.clk, CLK_PERIOD, 'ns').start())
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    dut.scram_rst.value = 1
    await RisingEdge(dut.clk)
    dut.scram_rst.value = 0


@cocotb.test()
async def test_par_scrambler(dut):

    # Asign the polynomial to the DUT
    dut.Polynomial.value = POLY

    # clock and reset
    await init_test(dut)

    await RisingEdge(dut.clk)

    # Stimulus data generation
    data_in = []
    data_out = []
    expected_out = []
    for i in range(20):
        rand = getrandbits(len(dut.data_in))
        expected = rand ^ POLY
        # data_in.append(rand)
        data_in.append(i)
        expected_out.append(expected)
        # L = LFSR(fpoly=FPOLY)

    # Apply input data and enable scrambler
    for data in range(len(data_in)):
        dut.data_in.value = data
        dut.scram_en.value = 1
        await RisingEdge(dut.clk)
        data_out.append(int(dut.data_out.value))

    dut.scram_en.value = 0

    # Wait for a few more clock cycles
    for _ in range(5):
        await RisingEdge(dut.clk)

    assert data_out == expected_out

    # Finish the test
    for _ in range(2):
        await RisingEdge(dut.clk)
