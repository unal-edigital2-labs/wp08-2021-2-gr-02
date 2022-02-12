1. [ Radar. ](#radar)

<a name="radar"></a>
# Radar

El radar se conforma por el ultrasonido y un servomotor

[![Captura-de-pantalla-de-2022-02-11-21-48-03.png](https://i.postimg.cc/grbk62Hn/Captura-de-pantalla-de-2022-02-11-21-48-03.png)](https://postimg.cc/JHKWfmgL)

<a name="us"></a>
## Ultrasonido

El modelo utilizado es el HC-sr04, que de acuerdo con el [documento](../datasheets/HCSR04.pdf) proporcionado por el fabricante, el ultrasonido debe recibir una señal de 10 us por el pin trig, de esta manera, se emiten 8 rafagas de sonido a 40 kHz, posteriormente, se cuenta el tiempo que transcurre hasta que el sonido vuelva. A partir de esto, se establece que la distancia es igual al tiempo en microsegundos dividido entre 58. Con estas indicaciones se implementa la siguiente maquina de estados: