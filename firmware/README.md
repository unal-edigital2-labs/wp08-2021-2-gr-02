1. [ Ultrasonido ](#us)
2. [ Servomotor ](#pwm)
3. [ Motores ](#w)
4. [ Infrarojos ](#ir)

<a name="us"></a>
## Ultrasonido

Se implementa el código para hacer la prueba de funcionamiento del ultrasonido con el cual se iluminan los leds de la fpga dependiendo de la distancia a la que se encuentre de un obstaculo presentando algunas lecturas falsas, pues detectaba objetos cerca ahún cuando no los hubiera:


``` c
static int ultraSound_test(void)
{
	ultraSound_cntrl_init_write(1);
	// Se esperan 2 ms para dar tiempo a que el registro done se actualice
	delay_ms(2);
	while(true){
		if(ultraSound_cntrl_done_read() == 1){
			// Si done es 1, se lee y se retorna la distancia
			int d = ultraSound_cntrl_distance_read();
			ultraSound_cntrl_init_write(0);
			return d;
		} 
	}	
}

```

<a name="pwm"></a>
## Servomotor

Se implementa la prueba con el servomotor en la que se gira hacia la izquierda, hacia la derecha y hacia el frente.

```python
static void PWMUS_test(void)
{
	PWMUS_cntrl_pos_write(0);
	delay_ms(1000);
	PWMUS_cntrl_pos_write(1);
	delay_ms(1000);
	PWMUS_cntrl_pos_write(2);
	delay_ms(1000);
	PWMUS_cntrl_pos_write(3);
}
```

<a name="w"></a>
## Motores

Se realiza la prueba de funcionamiento de los motores evidenciando que la tensión de 5 voltios no es suficiente para mover ambos, por lo tanto se procede a usar un adaptador de 12 voltios con el cual el resultado es satisfactorio.

```python

static void w_test(void){
	int state = 0;
	while(true){
		switch(state){
			case 0: 
				wheels_cntrl_state_write(0);
				delay_ms(1000);
				state = 1;
				break;
			case 1: 
				wheels_cntrl_state_write(1);
				delay_ms(1000);
				state = 2;
				break;
			case 2: 
				wheels_cntrl_state_write(2);
				delay_ms(1000);
				state = 3;
				break;
			case 3: 
				wheels_cntrl_state_write(3);
				delay_ms(1000);
				state = 4;
				break; 
			case 4: 
				wheels_cntrl_state_write(4);
				delay_ms(1000);
				wheels_cntrl_state_write(3);
				return;
				break; 

		}
	}
}

```

<a name="ir"></a>
## Infrarojos

Se implementa el código el cual muestra en pantalla un arreglo de cinco bits que indican 1 cuando se detecta un objeto y un 0 cuando no.

```python
static void IR_test(void)
{
	printf("Test del infra rojo... se interrumpe con el botton 1\n");
	while(!(buttons_in_read()&1)){
		bool L = IR_cntrl_L_read();
		bool LC = IR_cntrl_LC_read();
		bool C = IR_cntrl_C_read();
		bool RC = IR_cntrl_RC_read();
		bool R = IR_cntrl_R_read();

		bool IR[5] = {L, LC, C, RC, R};

		for(int i = 0; i<5; i++){
			printf("%i, ", IR[i]);
		}
		printf("\n");
	}
}

```