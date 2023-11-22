# Introducción

## Historia de las Matrices de Puertas Programables en Campo (FPGAs)

## FPGAs en la Actualidad

### Lógica Programable

La lógica programable está compuesta por LUTs (tablas de búsqueda, a veces también llamadas LEs - elementos lógicos), que son celdas basadas en SRAM que realizan funciones definidas por el usuario según el flujo de bits de configuración de la FPGA. La estructura exacta de la LUT varía según el fabricante y la familia de dispositivos; aquí se muestra la estructura de la LUT de la familia de dispositivos Cyclone IV de Altera.

### Recursos de Enrutamiento

Para habilitar las conexiones entre los elementos lógicos y entre los elementos lógicos y otras partes del chip, la FPGA contiene la interconexión. Estos son senderos de conexión "hardened" dentro del chip, ya sea de propósito general para el diseño del usuario o con una función específica, como redes de distribución de reloj. Los senderos de distribución de reloj están diseñados de manera que proporcionen una distribución uniforme del reloj con una desviación mínima en todas las partes del chip. Esta es una parte importante de la estructura de interconexión, ya que la mayoría de los diseños de FPGA son síncronos y la calidad de la distribución del reloj afecta directamente la frecuencia máxima a la que puede funcionar correctamente el diseño del usuario (esta frecuencia máxima se llama fmax). Además, esta es la parte de una FPGA que ocupa la mayoría de los recursos de silicio del chip. Algunas estimaciones indican que hasta el 90% del dado de silicio está dedicado al enrutamiento.

### Memoria Integrada

Muchos de los diseños de FPGA requieren algún tipo de memoria rápida para el almacenamiento temporal de resultados intermedios, búferes de datos y otros. Por esta razón, el chip contiene bloques de memoria integrada. Estas son unidades de memoria SRAM "hardened", generalmente configurables para diferentes tamaños de memoria, anchos de datos o acceso de puerto único/dual.

### Multiplicadores Integrados

Dado que las FPGAs son adecuadas para el procesamiento de señales digitales (DSP), la mayoría de las familias de dispositivos contienen multiplicadores "hardened". Esto proporciona al diseñador bloques optimizados con un rendimiento (fmax) mayor que las implementaciones "soft" (en lógica) y también libera recursos lógicos que de otra manera serían necesarios para implementar la función del multiplicador. Los bloques DSP suelen ser de punto fijo; las familias de FPGAs más nuevas y avanzadas implementan componentes "hardened" optimizados para punto flotante.

### Software de Desarrollo

## Procesamiento de Video en una FPGA

Procesar un flujo de video generalmente implica operaciones en la sincronización de la señal de video o en los datos de mapa de bits crudos de cuadros o campos individuales. La arquitectura de la FPGA es adecuada para el procesamiento de video por las siguientes razones:
- La generación de temporización de video es relativamente sencilla con una FPGA. Incluso la estructura lógica de las familias de FPGAs de bajo costo suele ser capaz de admitir componentes IP de 150+ MHz, lo que permite la generación de resoluciones HD.
- Procesar los datos de cuadro crudos puede aprovechar los bloques DSP "hardened" para facilitar los requisitos de temporización para la estructura lógica en sí. Junto con la canalización de las operaciones individuales del algoritmo, esto permite el diseño de rutas de procesamiento de video complejas incluso con resoluciones HD.
- Al estar "cerca del hardware", los algoritmos en una FPGA pueden ser más eficientes en términos de potencia que los sistemas que utilizan un núcleo de CPU para realizar funciones de procesamiento.
- Debido a la flexibilidad de la arquitectura de la FPGA, la ruta de procesamiento de video puede adaptarse a los requisitos específicos del proyecto.
- La flexibilidad de la arquitectura de la FPGA puede resultar útil para pequeñas series de producción, donde los costos de desarrollo de una solución ASIC pueden ser prohibitivos.
Por estas razones, las funciones de procesamiento requeridas para el proyecto descrito en este trabajo se implementaron en una FPGA.

# Estándares de Transporte de Video en Difusión

Hoy en día, con algunas excepciones (por ejemplo, la interfaz VGA), la representación de la señal de video ha pasado del dominio analógico al digital. La ventaja más evidente de la representación digital sobre la analógica es que los datos de video no se alteran de ninguna manera durante la transmisión. Con la representación analógica, esto no era posible debido a efectos como el ruido y las pérdidas de línea, que en la mayoría de los casos corrompían la información transmitida.

Independientemente del estándar de interfaz de video seleccionado, los datos de video se dividen en imágenes discretas llamadas fotogramas. Un fotograma es una imagen de mapa de bits, transferida a través de la interfaz de transporte de arriba a abajo, línea por línea, con cada línea de imagen transmitida de izquierda a derecha. Por lo tanto, la transmisión de un fotograma comienza con el píxel superior izquierdo y termina con el píxel inferior derecho. La tasa a la que se transfieren los fotogramas de video se llama frecuencia de fotogramas.

El formato de video puede ser progresivo o entrelazado. En el flujo de video progresivo, un fotograma se transfiere en su totalidad, lo que significa que es una representación completa de la imagen de video en un punto en el tiempo. Con el flujo entrelazado, los fotogramas se dividen en mitades llamadas campos. Los campos pueden ser pares o impares, donde el campo impar contiene líneas impares del fotograma y el campo par contiene líneas pares. Cuando el flujo se transfiere como video entrelazado, el movimiento parece más suave porque este formato duplica efectivamente la resolución temporal del flujo (en comparación con un flujo progresivo con la misma resolución y ancho de banda).

Los datos de video representan la escena en un espacio de color predefinido. Los espacios de color más comúnmente utilizados son RGB y YCbCr. Con el espacio de color RGB, el píxel tiene componentes de color rojo, verde y azul para identificar su color. El estándar RGB se utiliza ampliamente en la industria de PC para la representación de datos de video y como formato de salida de la tarjeta gráfica. Cuando se utiliza el espacio de color YCbCr, el píxel tiene coordenadas de luminancia (brillo) y crominancia (color) para identificar el color. La conversión entre estos espacios de color puede ser desde bastante sencilla hasta bastante compleja, según la calidad de conversión solicitada.

La resolución horizontal y vertical del fotograma, la frecuencia de fotogramas, el espacio de color y el identificador progresivo/entrelazado forman juntos un formato de video. Los formatos de video están estandarizados por organizaciones como VESA o SMPTE. Este capítulo ofrece una visión general de los estándares de transporte de video utilizados para la entrada y salida de video del sistema de procesamiento de video presentado.

## Datos Digitales Paralelos
La representación de datos de video como un bus paralelo con reloj es más común al conectar diferentes circuitos integrados en una placa de circuito impreso. El bus contiene una señal de reloj maestro, señales de sincronización horizontal y vertical, un indicador de imagen activa (señal de datos válidos), un identificador de campo para formatos entrelazados y los propios datos de video. Este formato con sincronización horizontal y vertical separada se utiliza más comúnmente, probablemente por su universalidad.

Aunque se puede utilizar la sincronización incorporada (las señales de sincronización no son cables separados, sino que se incorporan como secuencias especiales directamente en los datos de video), esto puede causar complicaciones de diseño al usar circuitos integrados de procesamiento de video que esperan secuencias de sincronización incorporadas diferentes debido a diferentes estándares (por ejemplo, BT656 vs BT1120). El formato de transmisión paralela requiere que las longitudes de los cables individuales de bits estén muy cerca entre sí para garantizar que el frente de onda de píxeles esté correctamente alineado en el lado del receptor. Con las altas resoluciones de hoy y, por lo tanto, las altas frecuencias de reloj de píxeles, este formato de datos también puede causar problemas con la diafonía de señales o reflejos de diferencias de impedancia, por lo tanto, es una buena práctica utilizar algún tipo de terminación tanto en el lado del transmisor como en el del receptor.

## Interfaz Digital Serial (SDI)
La interfaz digital serial [18] es un estándar de transporte de video utilizado principalmente en las industrias de radiodifusión y médica. Utiliza un cable coaxial blindado como medio y permite tasas de transferencia de 270 Mbit/s a 3 Gbit/s. Puede considerarse como una encapsulación serial de datos digitales paralelos. En el lado de transmisión, los datos se serializan a una forma serial de alta velocidad y en el lado de recepción, los datos se deserializan de nuevo al formato paralelo.

SDI utiliza el esquema de codificación NRZI para codificar datos y un registro de desplazamiento de retroalimentación lineal para barajar los datos y controlar la disparidad de bits. El flujo de video también puede incluir sumas de comprobación CRC (Cyclic Redundancy Check) para verificar que la transmisión ocurrió sin errores.

## Interfaz de Video Digital (DVI)
DVI es una interfaz para transferir video digital y se utiliza con frecuencia en la industria de PC. La interfaz utiliza TMDS (Transición Minimizada de Señal Diferencial) para transferir datos sobre cuatro pares trenzados (tres para datos y uno para el reloj) de cables. Dado que esta interfaz se utiliza con frecuencia para conectar un puerto gráfico de una computadora a una pantalla, DVI también incluye canales de datos de soporte para permitir que la computadora identifique el dispositivo al que se está conectando. Esta interfaz se llama EDID y es básicamente una EEPROM serial con información sobre el proveedor de la pantalla y las resoluciones admitidas.

Esta interfaz también puede considerarse como una encapsulación serial de datos paralelos, pero en comparación con SDI, utiliza tres canales de datos seriales para transportar los datos. Esto reduce los requisitos de ancho de banda para un solo canal serial y, por lo tanto, reduce los requisitos de calidad

# Requisitos del Proyecto

# Análisis de la Familia de Dispositivos

# Evaluación de Núcleos IP Comerciales

# Estructura del Sistema Seleccionada

## Diagrama de Bloques

## Submódulos
## Submódulos
## Submódulos

# Implementación

# Flujo de Diseño de FPGA

# Resultados

# Conclusión

# Bibliografía
