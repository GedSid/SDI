## Inserción de Números de Línea

Este módulo cambia el formato del valor de número de línea de 11 bits en dos palabras de 10 bits y las inserta en sus posiciones adecuadas inmediatamente después de la palabra EAV. El mismo valor de número de línea se inserta en ambos canales de video.

En el estándar SMPTE 292M, los números de línea de 11 bits deben formatearse en dos palabras de 10 bits con el siguiente formato para cada palabra:


|  Bit   |  9   |  8   |  7   |  6   |  5   |  4   |  3   |  2   |  1   |  0   |
|--------|------|------|------|------|------|------|------|------|------|------|
| Word 0 | ~ln6 | ln6  | ln5  | ln4  | ln3  | ln2  | ln1  | ln0  |  0   |  0   |
| Word 1 |  1   |  0   |  0   |  0   | ln10 | ln9  | ln8  | ln7  |  0   |  0   |


Este módulo es puramente combinatorio y no tiene registros de retardo.

---------------------------------------------------------------------

## Detector de Líneas

Este módulo examina un flujo de datos de alta definición (HD) y detecta el formato de transporte. Detecta todos los estándares de vídeo actualmente admitidos por SMPTE 292M-2006, además de los formatos de vídeo descritos en SMPTE RP 211. El módulo también puede utilizarse con un receptor 3G-SDI.

Detecta el timing de transporte y no necesariamente el formato de vídeo real. Cuenta palabras y líneas para determinar el estándar de vídeo. No depende de la inclusión de paquetes ANC que identifican el estándar de vídeo. Además, produce un valor de número de línea que cambia en el flanco de subida del reloj después de la palabra XYZ de la EAV, por lo que es válido para su inserción en el campo ln_o de un flujo HD-SDI.

Solamente requiere como entrada uno de los canales del flujo de vídeo, ya sea Y o C y las señales decodificadas eav y sav.

Cuando cambie el estándar de vídeo de entrada, se deben enviar algunos fotogramas de vídeo (determinados por MAX_ERRCNT) antes de comenzar el proceso de identificación y lockeo al nuevo formato de vídeo. Esto es para evitar que los errores por el cambio en el standard del vídeo hagan que el módulo pierda el lockeo. Sin embargo, también aumenta la latencia para que el módulo se lockee a un nuevo estándar cuando el estándar de vídeo de entrada cambia deliberadamente. Si alguna lógica externa a este módulo sabe que se ha realizado un cambio deliberado en el estándar de vídeo de entrada, puede afirmar la entrada reacquire de este módulo durante un ciclo de reloj para forzar al módulo a comenzar inmediatamente el proceso de identificación y lockeo al nuevo estándar de vídeo.

El módulo genera las siguientes salidas:

- **locked:** Indica cuando el módulo ha bloqueado al estándar de vídeo entrante. Las salidas std y ln_o solo son válidas cuando locked es 1.
- **std:** Un código de 4 bits que indica qué formato de transporte se ha detectado, codificado de la siguiente manera (las tasas son tasas de fotogramas).
    - 0000: SMPTE 260M 1035i           30Hz
    - 0001: SMPTE 295M 1080i           25Hz
    - 0010: SMPTE 274M 1080i o 1080sF  30Hz
    - 0011: SMPTE 274M 1080i o 1080sF  25Hz
    - 0100: SMPTE 274M 1080p           30Hz   
    - 0101: SMPTE 274M 1080p           25Hz   
    - 0110: SMPTE 274M 1080p           24Hz
    - 0111: SMPTE 296M 720p            60Hz
    - 1000: SMPTE 274M 1080sF          24Hz
    - 1001: SMPTE 296M 720p            50Hz
    - 1010: SMPTE 296M 720p            30Hz
    - 1011: SMPTE 296M 720p            25Hz
    - 1100: SMPTE 296M 720p            24Hz
    - 1101: SMPTE 296M 1080p           60Hz    (Solo 3G-SDI nivel A)
    - 1110: SMPTE 296M 1080p           50Hz    (Solo 3G-SDI nivel B)
- **ln_o:** Un código de 11 bits de número de línea que indica el número de línea actual. Este código cambia en el flanco de subida del reloj cuando tanto xyz como eav están afirmados. Esto permite que

---------------------------------------------------------------------