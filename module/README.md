1. [ Ultrasonido. ](#us)


<a name="us"></a>
## Ultrasonido

#Mapa de memoria

|Registro |Dirección |Tipo|
| ------------- | ------------- |-------------|
|init |	0x82004000 |	rw|
|distance |	0x82004004 |	ro|
|done |	0x82004008 |	ro|


El modelo utilizado es el HC-sr04, que de acuerdo con el [documento](../datasheets/HCSR04.pdf) proporcionado por el fabricante, el ultrasonido debe recibir una señal de 10 us por el pin trig, de esta manera, se emiten 8 rafagas de sonido a 40 kHz, posteriormente, se cuenta el tiempo que transcurre hasta que el sonido vuelva. A partir de esto, se establece que la distancia es igual al tiempo en microsegundos dividido entre 58. Con estas indicaciones se implementa la siguiente maquina de estados:

