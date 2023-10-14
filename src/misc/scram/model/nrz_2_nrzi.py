def nrz_2_nrzi(input_bits):
  """Converts an NRZ signal to an NRZI signal.
  Args: input_bits: A list of bits representing the NRZ signal.
  Returns: A list of bits representing the NRZI signal.
  """

  for bit in input_bits:
    if bit == 1:
        current_state = 1 - current_state
    nrzi_signal.append(current_state)

  return nrzi_signal

# Example usage:
# input_bits = [0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0]
nrz_signal = ['1011001011']
input_bits = nrz_to_nrzi(input_bits)
print(input_bits)