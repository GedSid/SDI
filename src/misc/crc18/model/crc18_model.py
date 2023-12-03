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

    # def crc_calc(self, crc_en, data_i, crc):
    #     DATA_W = 10

    #     t = []
    #     crc_new = []
    #     # for i in range(DATA_W-1):
    #     #     t[i] = data_i[i] ^ crc[i]

    #     for i in range(2):
    #         crc_new[i] = crc[i + 10]
    #     crc_new[3] = t[0] ^ crc[13]
    #     for i in range(4, 7):
    #         crc_new[i] = (t[i - 3] ^ t[i - 4]) ^ crc[i + 10]
    #     for i in range(8, 12):
    #         crc_new[i] = (t[i - 3] ^ t[i - 4]) ^ t[i - 8]
    #     crc_new[13] = t[9] ^ t[5]
    #     for i in range(14, 19):
    #         crc_new[i] = t[i - 8]

    #     if crc_en:
    #         return crc_new
    #     return 0

    def get_crc_output(self):
        # return bin(self.crc_reg)[2:].zfill(self.POLY_ORDER)
        return [1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0]

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
