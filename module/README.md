1. [ Ultrasonido. ](#us)
2. [ Servomotor. ](#servo)


<a name="us"></a>

## Ultrasonido

# Mapa de memoria

|Registro |Dirección |Tipo|
| ------------- | ------------- |-------------|
|init |	0x82004000 |	rw|
|distance |	0x82004004 |	ro|
|done |	0x82004008 |	ro|


El modelo utilizado es el HC-sr04, que de acuerdo con el [documento](../datasheets/HCSR04.pdf) proporcionado por el fabricante, el sensor emite ondas de sonido a 40 kHz cuando se el trigger se pone en alto por más de 10us, las ondas rebotan y vuelven al sensor cierto tiempo después, para calcular la distancia se multiplica el tiempo que tardó la onda en ir y volver por la velocidad del sonido y se divide entre 2, a continuación se presenta la máquina de estados utilizada:

En el estado init las variables done, counter y distance se inicializan y pasa al estado pulse

``` verilog
parameter Start = 0, Pulse = 'd1, Echo = 'd2;
always @ (posedge newCLK)begin

    case(status)
        Start:  begin
                    if(init) begin
                        done = 0;
                        counter = 0;
                        distance = 0;
                        status = Pulse;
                    end
                end

```

En el estado pulse se activa el trigger durante 11 us haciendo que el echo emita una señal, después se pasa al estado Echo

``` verilog 
Pulse:  begin
                    trig = 1'b1;
                    counter = counter + 1'b1;
                        if(counter == 'd11)begin
                            trig = 0;
                            counter = 0;
                            status = Echo;
                        end
                end

```

En el estado Echo se cuenta el tiempo que transcurre desde que se emitió la señal hasta que regresa, una vez regresa, se calcula la distancia teniendo en cuenta el tiempo que demoró la señal. En caso de que la variable echo no reporte la emisión de la señal, se vuelve al estado pulse para trater de enviar la señal de nuevo.

``` verilog
Echo:   begin
                      if(echo)begin
                        echoStart = 1;
                        counter = counter + 1'b1;
                      end
                      if(echo == 0 && echoStart == 1)begin
                        
                        if(counter == 0) status = Pulse;
                        else begin
                            distance = counter/'d58;
                            status = Start;
                            done = 1;
                        end
                      end
                end
```

Luego en python se establece el registro init como storage, echo y trig son pines físicos, distancia y done son registros de status.

``` python
class US(Module, AutoCSR):
    def __init__(self, echo, trig):
        self.clk = ClockSignal()
        self.init = CSRStorage(1)
        self.echo = echo
        self.trig = trig
        self.distance = CSRStatus(9)
        self.done = CSRStatus(1)
```

En el archivo buildSoCproject se crea el submodulo y se importan los pines de entrada y salida del modulo:

``` python
		#ultraSound
		SoCCore.add_csr(self,"ultraSound_cntrl")
		self.submodules.ultraSound_cntrl = ultraSound.US(platform.request("echo"), platform.request("trig"))
```

<a name="servo"></a>
## Servomotor

El servomotor es el encargado de girar al ultrasonido para que este pueda hacer las lecturas del mapa, 