import cocotb
from cocotb.runner import get_runner
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from random import getrandbits

async def init(dut):
    cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut.data_i.value = 0
    dut.rst.value = 1
    dut.clk_en.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0
    await ClockCycles(dut.clk, 10)

@cocotb.test()
async def test_sdi_bit_rep(dut):
    await init(dut)

    for _ in range(1):
        data_i = getrandbits(len(dut.data_i))
        dut.data_i.value = data_i
        dut.clk_en.value = 1
        await ClockCycles(dut.clk, 1)

        data_o = dut.data_o.value
        print(data_o)
        await ClockCycles(dut.clk, 10)
        assert 0 == bin(data_o).count('1') % 2
