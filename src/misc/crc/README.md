## sarasa



### CRC Insert

  This module `crc_insert` has 2 main functions. The first one, es to generate timing control signals for the CRC. Acording to HD-SDI standard, the CRC must being with the first word after the SAV and end after the second line number word.

  The `crc_en` signal should be asserted during the XYZ word of the SAV since the next word after the SAV XYZ word is the first word to be included into the new CRC calculation.

  The second one, to insert the CRC in the data stream after the line number.
  the 18 bit CRC value is inserted into two 10 bit words. To that end the 8th bit is negated and inserted at the beginning of the first word.

  This module has 2 clocks of delay, 1 is because of the `crc18_smpte`.

### CRC 18 bit SMPTE

This module `crc18_smpte` calculates the 18 bits CRC define the SMPTE-292M (HD-SDI) standards. It is design with the polynomial *x^18+x^5+x^4+1*. The module has one clock of latency. The `crc_clr` input must be asserted with the first word of a new calculation.

---------------------------------------------------------------------
