# Proyecto-Grupo2

### Integrantes
- Omar David Velasquez
- Jhon Edison Rios Fonseca

## Introducción

En este trabajo se presenta un proyecto el cual tiene como objetivo implementar un robot cartógrafo que recorre un laberinto e identifica algunas características de la pista y responde a dichas características como la elección de tomar un camino u otro dependiendo de las posibilidades y el procesamiento que ha realizado a lo largo del recorrido; determinar si en una pared se encuentra una figura de alguna forma y color específicos; recibir y transmitir datos mediante bluetooth; medir los niveles de temperatura y humedad.

A continuación se muestra la arquitectura básica que tendrá el SoC del proyecto .

## SoC

[![Captura-de-pantalla-de-2022-02-11-21-08-48.png](https://i.postimg.cc/9Mc36qFm/Captura-de-pantalla-de-2022-02-11-21-08-48.png)](https://postimg.cc/R3pbfhHy)

## Mapa de Memoria

| csr_base | Dirección |
| ------------- | ------------- |
|leds   |	0x82000000 |
|switchs |	0x82000800 |
|buttons |	0x82001000 |
|display |	0x82001800 |
|ledRGB_1 |	0x82002000 |
|ledRGB_2 |	0x82002800 |
|vga_cntrl |	0x82003000 |
|i2c_cntrl |	0x82003800 |
|ultraSound_cntrl |	0x82004000 |
|PWMUS_cntrl |	0x82004800 |
|IR_cntrl |	0x82005000 |
|wheels_cntrl |	0x82005800 |
|ctrl |	0x82006000 |
|timer0 |	0x82006800 |
|uart |	0x82007000 |


## [Módulos](https://github.com/unal-edigital2-labs/wp08-2021-2-gr-02/tree/main/module) 

- Servomotor
- Ultrasonido
- Infrarojos
- Motores

