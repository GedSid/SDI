def nrz_2_nrzi_bit(input_bits):
  """Converts an NRZ signal to an NRZI signal.
  Args: input_bits: A list of bits representing the NRZ signal.
  Returns: A list of bits representing the NRZI signal.
  """

  nrzi_signal = []  # Initialize an empty list to store the NRZI signal
  current_state = 0  # Initialize the current state to 0 (low)

  for bit in input_bits:
    if bit == 1:
        current_state = 1 - current_state
    nrzi_signal.append(current_state)

  return nrzi_signal

def nrz_2_nrzi(input_bits):

  nrzi_signals = []

  for input_bits in input_words:
    nrzi_signal = nrz_2_nrzi_bit(input_bits)
    nrzi_signals.append(nrzi_signal)

  return nrzi_signals

# Example usage:
# input_bits = [0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0]
# input_bits = nrz_to_nrzi(input_bits)
# print(input_bits)

input_words = [
  [1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
  [0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
  [1, 1, 0, 0, 1, 1, 0, 0, 1, 1],
  [0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0]
]

nrzi_signals = nrz_2_nrzi(input_words)
for nrzi_signal in nrzi_signals:
    print(nrzi_signal)