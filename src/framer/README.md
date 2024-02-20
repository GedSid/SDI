## SMPTE 292M HD-SDI Framer

Es una norma para la transmisión de video digital de alta definición a través de un enlace serial. El estándar SMPTE 259M SD-SDI es una norma equivalente para video. Este módulo realiza el formateo en los datos decodificados.

- **Entrada de Datos:**
  - En modo HD-SDI, el puerto de entrada `data_i` es de 20 bits.
  - En modo SD-SDI, solo se utilizan 10 bits.

- **Modo de `frame_en`:**
  - `frame_en` atado alto: Resincroniza en cada detección de TRS.
  - `frame_en` atado a `nsp`: Implementa filtrado TRS sin resincronización inmediata.
  - `frame_en` atado bajo: Desactiva la función de formateo automático.

### Detector HD TRS y Codificador de Desplazamiento

El detector HD TRS identifica la secuencia TRS de 60 bits que consiste en 20 '1s' seguidos por 40 '0s'. El detector tiene dos niveles principales: un detector de unos y un detector de ceros.

- **Detector de unos y ceros:**
  - Busca 20 unos consecutivos en `hd_in_1`.
  - Busca 20 ceros consecutivos en `hd_in_0`.
  - Salidas almacenadas en vectores `hd_ones_in`, `hd_zeros_in`, y `hd_zeros_dly`.

- **Generación de Resultados:**
  - Se crea `hd_is_trs` mediante OR entre los vectores mencionados.
  - `hd_trs_detected` se activa cuando se detecta un TRS.
  - `hd_bin_offset` se genera desde `hd_is_trs`.

### Detector SD TRS

El detector SD TRS encuentra preámbulos TRS de 30 bits (0x3ff, 0x000, 0x000) en la secuencia de datos de entrada.

- **Estructura del Detector:**
  - Utiliza una serie de compuertas AND y NOR de 10 bits para examinar cada posición posible en el vector de entrada de 39 bits.
  - Salidas en vectores `sd_trs1_match`, `sd_trs2_match`, y `sd_trs2_match`.

- **Generación de Resultados:**
  - AND de los vectores anteriores crea `sd_trs_all_match`.
  - Un caso basado en `sd_trs_all_match` genera `sd_offset_bin` y activa `sd_trs_error` en caso de errores.

