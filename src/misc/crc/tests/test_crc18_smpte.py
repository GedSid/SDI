import sys
sys.path.insert(0, '../../../../src/misc/crc/model')
from crc18_model import crc18_smpte_model


import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge # , Timer


CLK_PERIOD = 13.47  # ns (74.25 MHz)
DATA_W = 10


async def init_test(dut):
  dut.rst.value = 1
  dut.nrzi_en.value = 0
  start_soon(Clock(dut.clk, CLK_PERIOD, 'ns').start())
  for _ in range(5):
    await RisingEdge(dut.clk)
  dut.rst.value = 0
  await RisingEdge(dut.clk)


def binary_number_to_array(binary_number):
    binary_string = bin(binary_number)
    binary_string = binary_string[2:]
    binary_array = [int(bit) for bit in binary_string]
    return binary_array


@cocotb.test()
async def crc_basic_test(dut):
  """Test 1 word"""

  model = crc18_smpte_model()

  input_bits = 0b1010101010
  crc_clr = 0
  crc_en = 1

  input_vec = binary_number_to_array(input_bits)
  print(input_vec)
  model.update_crc(input_vec, crc_clr, crc_en)
  output_bit = model.get_crc_output()
  print(output_bit)
  
  clock and reset
  await init_test(dut)
  print("test 3")
  dut.crc_clr.value = 1
  await RisingEdge(dut.clk)
  dut.crc_clr.value = 0
  await RisingEdge(dut.clk)

  print("test 4")
  dut.data_i.value = int(input_bits)
  dut.crc_en.value = 1
  await RisingEdge(dut.clk)
  await RisingEdge(dut.clk)
  print(binary_number_to_array(dut.data_o.value))

  assert binary_number_to_array(dut.data_o.value)[:9] == output_bit[-9:], f"CRC consersion result is incorrect: {binary_number_to_array(dut.data_o.value)[:9]} != {output_bit[-9:]}"

if __name__ == "__main__":
  crc_basic_test()