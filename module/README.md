1. [ Ultrasonido. ](#us)
2. [ Servomotor. ](#servo)
3. [ Motores. ](#motor)
4. [ InfraRojos. ](#ir)


<a name="us"></a>

## Ultrasonido

# Mapa de memoria

|Registro |Dirección |Tipo|
| ------------- | ------------- |-------------|
|init |	0x82004000 |	rw|
|distance |	0x82004004 |	ro|
|done |	0x82004008 |	ro|


El modelo utilizado es el HC-sr04, que de acuerdo con las [especificaciones](../datasheets/HCSR04.pdf) del fabricante, el sensor emite ondas de sonido a 40 kHz cuando se el trigger se pone en alto por más de 10us, las ondas rebotan y vuelven al sensor cierto tiempo después, para calcular la distancia se multiplica el tiempo que tardó la onda en ir y volver por la velocidad del sonido y se divide entre 2, a continuación se presenta la máquina de estados utilizada:

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

# Mapa de memoria
|Registro  | posición | Tipo |
|----------|--------|--------|
PWM	| 0x82004800	| rw |


El servomotor es el encargado de girar al ultrasonido para que este pueda determinar la ubicación de las paredes, dado que los tres movimientos que debe realizar son hacia la derecha, hacia el frente y hacia la izquierda, para esto se establecen siertos valores de pwm en la [hoja de especificaciones](../datasheets/sg90_datasheet.pdf) del fabricante en la cual se indica que la señal pwm debe ser de 50 Hz y para la posicion a 0° debe tener un ancho de pulso de 1 ms, para 180° el ancho debe ser de 2 ms. De este modo, el código implementado en verilog es el siguiente

``` verilog
always@(posedge clk)begin
	contador = contador + 1;
	if(contador =='d1_000_000) begin
	   contador = 0;
	end
	
	case(pos)
        2'b00:  servo = (contador < 'd50_000) ? 1:0;
        
        2'b01:  servo = (contador < 'd150_000) ? 1:0;
        
        2'b10:  servo = (contador < 'd250_000) ? 1:0;
        
        default:servo = (contador < 'd50_000) ? 1:0;
    endcase

end
```

En python se importa el modulo donde se maneja el registro pos como Storage para que se pueda editar desde C, y la señal servo como una conexion externa en la FPGA.

``` python
class servoUS(Module, AutoCSR):
    def __init__(self, servo):
            self.clk = ClockSignal()
            self.pos = CSRStorage(2)
            self.servo = servo

```

y se añade el submodulo e importan los pines

``` python
#PWMUS
		SoCCore.add_csr(self,"PWMUS_cntrl")
		self.submodules.PWMUS_cntrl = PWMUS.servoUS(platform.request("servo"))
```
<a name="motor"></a>

## Motores

# Mapa de memoria 
| Registro | Posición | Tipo |
|-------|-------|---------|
|motores |	0x82005800 |rw|

Los motores para el desplazamiento del robot se implementan con un puente H L298N para lo cual se establecen estados en los que puede movilizarce el robot (giro derecha, giro izquierda, hacia el frente, hacia atras, quieto y giro de 180°), el código en verilog para cada posición es el siguiente

``` verilog
       case(state)
        // Recto
        3'b000:  begin
                    right[0] = 1;
                    right[1] = 0;
                    left[0]  = 1;
                    left[1]  = 0;
                end

        //Derecha
        3'b001:  begin
                    right[0] = 0;
                    right[1] = 0;
                    left[0]  = 1;
                    left[1]  = 0;
                end
        //Izquierda
        3'b010:  begin
                    right[0] = 1;
                    right[1] = 0;
                    left[0]  = 0;
                    left[1]  = 0;
                end
        // Quieto
        3'b011:  begin
                    right[1] = 0;
                    right[0] = 0;
                    left[1]  = 0;
                    left[0]  = 0;
                end

        // Giro 180
        3'b100:  begin
                    right[0] = 0;
                    right[1] = 1;
                    left[0]  = 1;
                    left[1]  = 0;
                end
        // Retroceder
   	    3'b101:  begin
                    right[1] = 1;
                    right[0] = 0;
                    left[1]  = 1;
                    left[0]  = 0;
                end
	endcase
```

El código en python se agrega la señal del reloj y la variable state, la cual es de tipo storage. Las señales right y left son las que se usan en los pines del puente H para controlar las ruedas.


``` python

class wheels(Module, AutoCSR):
    def __init__(self, right, left):
            self.clk = ClockSignal()
            self.state = CSRStorage(3)
            self.right = right
            self.left = left

            self.specials += Instance("wheels",
                i_clk = self.clk,
                i_state = self.state.storage,
                o_right = self.right,
                o_left = self.left)

```
En el Soc se incluyen los pines a usar right y left y se realiza un barrido de 1 a 2 en left y right debido a que cada uno tiene 2 pines.

``` python

SoCCore.add_csr(self,"wheels_cntrl")
right = Cat(*[platform.request("right", i) for i in range(2)])
left = Cat(*[platform.request("left", i) for i in range(2)])
self.submodules.wheels_cntrl = wheels.wheels(right, left)
```
<a name="ir"></a>

## Infrarojos

# Mapa de memoria

| Registro | Posición | tipo |
|-------|--------|-------|
|IR_L |	0x82005000 |    ro|
IR_LC |	0x82005004	|	ro|
IR_C |	0x82005008	|	ro|
IR_RC |	0x8200500c	|	ro|
IR_R |	0x82005010	|	ro|

Los sensores infrarojos tienen un LED infrarojo y un foto diodo, cuando el LED emite luz y esta se refleja en el foto diodo, la salida del sensor marca una señal en alto, cuando hay una superficie negra no se refleja la luz y el sensor marca una señal en bajo.

Al robot se le incluirían cinco sensores infrarojos, uno sobre la franja negra, dos a los lados de la franja negra para garantizar que no se desviara y otros dós en los extremos para detectar las intersecciones en las que debía detenerse, el código de verilog implementado es el siguiente en el que se implemento un registro para cada sensor.

``` verilog

module infraRed(input iR, 
input iRC, 
input iC, 
input iLC, 
input iL, 
output reg L, 
output reg LC, 
output reg C, 
output reg RC, 
output reg R);

always @* begin
    L = iL;
    LC = iLC;
    C = iC;
    RC = iRC;
    R = iR;
end

endmodule

```
Para la implementación en python se llamó a cada uno de estos registros para leerlos a través del status y conocer la posicion en la que se encontraba el robot.

```python

from migen import *
from migen.genlib.cdc import MultiReg
from litex.soc.interconnect.csr import *
from litex.soc.interconnect.csr_eventmanager import *

class infra(Module, AutoCSR):
    def __init__(self, iR, iRC, iC, iLC, iL):

            self.iL = iL
            self.iLC = iLC
            self.iC = iC
            self.iRC = iRC
            self.iR = iR

            self.L = CSRStatus(1)
            self.LC = CSRStatus(1)
            self.C = CSRStatus(1)
            self.RC = CSRStatus(1)
            self.R = CSRStatus(1)

            self.specials += Instance("infraRed",
                i_iL = self.iL,
                i_iLC = self.iLC,
                i_iC = self.iC,
                i_iRC = self.iRC,
                i_iR = self.iR,
                o_L = self.L.status,
                o_LC = self.LC.status,
                o_C = self.C.status,
                o_RC = self.RC.status,
                o_R = self.R.status)

```

