class crc18_model:
  def __init__(self):
    self.POLY = 0b100000000001000001
    self.POLY_ORDER = 18
    self.crc_reg = 0

  def update_crc(self, data_i, crc_clr, crc_en):
    data = int(''.join(map(str, data_i)), 2)  # Convert data to an integer
    crc_old = self.crc_reg

    if crc_clr == 1:
      crc_old = 0

    temp = data ^ crc_old  # XOR data with the old CRC

    # Shift the CRC
    crc_new = (crc_old >> 1) ^ (self.POLY if (crc_old & 1) else 0)

    # Update the CRC with the XOR result
    crc_new = (crc_new & 0x1FFFF) | (temp << 17)

    if crc_en:
      self.crc_reg = crc_new

  def get_crc_output(self):
    return bin(self.crc_reg)[2:].zfill(self.POLY_ORDER)

# # Example usage
# simulator = crc18_model()

# # Input data and control signals
# data_i = [1, 0, 1, 1, 0, 0, 1, 0, 1, 1]
# crc_clr = 0
# crc_en = 1

# # Update CRC based on input data and control signals
# simulator.update_crc(data_i, crc_clr, crc_en)

# # Get the CRC output
# crc_output = simulator.get_crc_output()
# print("CRC Output:", crc_output)
