import sys
sys.path.insert(0, '../../../../src/misc/scram/model')
from nrz_2_nrzi_model import nrz_2_nrzi_model, nrz_2_nrzi_bit

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
async def nrzi_basic_test(dut):
  """Test 1 word"""

  input_bits = 0b1010101010
  input_vec = binary_number_to_array(input_bits)
  output_bit = nrz_2_nrzi_bit(input_vec)
  print(output_bit[-9:])

  # clock and reset
  await init_test(dut)
  dut.d_p_nrzi.value = 0
  await RisingEdge(dut.clk)

  dut.data_i.value = int(input_bits)
  dut.nrzi_en.value = 1
  await RisingEdge(dut.clk)
  await RisingEdge(dut.clk)
  print(binary_number_to_array(dut.data_o.value)[:9])

  assert binary_number_to_array(dut.data_o.value)[:9] == output_bit[-9:], f"NRZ to NRZI consersion result is incorrect: {binary_number_to_array(dut.data_o.value)[:9]} != {output_bit[-9:]}"


# @cocotb.test()
# async def nrzi_multiple_test(dut):
#   """Test 4 word"""

#   output_vec = []
#   output_words = []
#   input_words = [
#     0b1010101010,
#     0b1000000101,
#     0b1111100000,
#     0b1101001110
#   ]

#   for input_bits in input_words:
#     output_bits = nrz_2_nrzi_bit(binary_number_to_array(input_bits))
#     output_words.append(output_bits[-9:])
#   print(output_words)

#   # clock and reset
#   await init_test(dut)
#   await RisingEdge(dut.clk)

#   dut.d_p_nrzi.value = 0
#   dut.nrzi_en.value = 1
#   for i, input_bits in enumerate(input_words):
#     dut.data_i.value = int(input_bits)
#     if i == 0:
#       await RisingEdge(dut.clk)
#     else:
#       await RisingEdge(dut.clk)
#       dut.d_p_nrzi.value = dut.data_o.value[8]
#       output_vec.append(binary_number_to_array(dut.data_o.value)[:9])
      
#     print(i)
#     print(output_vec)
  
#   for output_bits, output in zip(output_words, output_vec):
#     # assert output_bits[-9:] == output[:9], f"NRZ to NRZI consersion result is incorrect: {output_bits[-9:]} != {output[:9]}"
#     assert output_bits == output, f"NRZ to NRZI consersion result is incorrect: {output_bits} != {output}"

if __name__ == "__main__":
  nrzi_basic_test()