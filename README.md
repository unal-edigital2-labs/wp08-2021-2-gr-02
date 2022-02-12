# Proyecto-Grupo2

### Integrantes
- Omar David Velasquez
- Jhon Edison Rios Fonseca

## Introducción

En este trabajo se presenta un proyecto el cual tiene como objetivo implementar un robot cartógrafo que recorre un laberinto e identifica algunas características de la pista y responde a dichas características como la elección de tomar un camino u otro dependiendo de las posibilidades y el procesamiento que ha realizado a lo largo del recorrido; determinar si en una pared se encuentra una figura de alguna forma y color específicos; recibir y transmitir datos mediante bluetooth; medir los niveles de temperatura y humedad.

[![Captura-de-pantalla-de-2022-02-12-03-23-51.png](https://i.postimg.cc/YqQGLWYx/Captura-de-pantalla-de-2022-02-12-03-23-51.png)](https://postimg.cc/HVssfjSJ)

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
|vga |	0x82003000 |
|i2c |	0x82003800 |
|ultraSonido|	0x82004000 |
|PWM |	0x82004800 |
|IR |	0x82005000 |
|Ruedas |	0x82005800 |
|ctrl |	0x82006000 |
|timer0 |	0x82006800 |
|uart |	0x82007000 |


## [Módulos](https://github.com/unal-edigital2-labs/wp08-2021-2-gr-02/tree/main/module) 

En esta sección se muestran los periféricos utilizados, así como sus respectivos drivers, el mapa de memoria de cada uno y la implementación en el SOC.

- Servomotor
- Ultrasonido
- Infrarojos
- Motores

## [Firmware](https://github.com/unal-edigital2-labs/wp08-2021-2-gr-02/tree/main/firmware)

En esta sección se presenta el código implementado en software para realizar el test de cada uno de los periféricos.


## Pruebas de Funcionamiento

En esta sección se presentan los videos con las pruebas realizadas a los periféricos.

- [Videos de funcionamiento](https://drive.google.com/drive/u/1/folders/1J8kimReBuna83oUG3pVrOriGDKc-3Bdm?pli=1)

## Complicaciones

- Desde un principio se percibía que el desarrollo del proyecto era demasiado complejo por tantos archivos, tanta teória extraña que no se entendía, combinar lenguajes de programación, etc. y esto llevó a una situación de posponer y evadir el tema al punto de que la entrega final estaba bastante cerca y no se había progresado demasiado, esto sumado con el tema del semestre dividido y recortado que apretó aún más las fechas de entrega para todas las materias, fueron los aspectos que más influyeron en la falta de calidad y compromiso con la materia.

