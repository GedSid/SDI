## Inserción de Números de Línea

Este módulo cambia el formato del valor de número de línea de 11 bits en dos palabras de 10 bits y las inserta en sus posiciones adecuadas inmediatamente después de la palabra EAV. El mismo valor de número de línea se inserta en ambos canales de video.

En el estándar SMPTE 292M, los números de línea de 11 bits deben formatearse en dos palabras de 10 bits con el siguiente formato para cada palabra:


|  b9   |  b8   |  b7   |  b6   |  b5   |  b4   |  b3   |  b2   |  b1   |  b0   |
|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
|  ~ln6 |  ln6  |  ln5  |  ln4  |  ln3  |  ln2  |  ln1  |  ln0  |   0   |   0   |
|   1   |   0   |   0   |   0   |  ln10 |  ln9  |  ln8  |  ln7  |   0   |   0   |


Este módulo es puramente combinatorio y no tiene registros de retardo.

---------------------------------------------------------------------