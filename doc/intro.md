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
