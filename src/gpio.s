

/*
pinos dos leds
*/


.equ on, 1
.equ CONTROL_MODULE, 0x44E10000
.equ  conf_gpmc_a5, 0x44E10854
.equ  conf_gpmc_a6, 0x44E10858
.equ  conf_gpmc_a7, 0x44E1085c
.equ  conf_gpmc_a8, 0x44E10860

.equ conf_gpmc_ad5,  0x814 + CONTROL_MODULE  //pin 22  - expansion p8
.equ conf_gpmc_ad2,  0x808 + CONTROL_MODULE  //pin 5   - expansion p8
.equ conf_gpmc_ad13, 0x834 + CONTROL_MODULE //pin 11  - expansion p8
.equ conf_gpmc_ad7,  0x81c + CONTROL_MODULE  //pin 4 - expansion p8
.equ conf_gpmc_ad3,  0x80c + CONTROL_MODULE  //pin 6 - expansion p8


.equ  GPIO1,  0x4804C000
.equ  GPIO_SETDATAOUT,    GPIO1 + 0x194
.equ  GPIO_CLEARDATAOUT,  GPIO1 +0x190
.equ  GPIO_OE,            GPIO1 + 0x134
.equ GPIO_DATAIN,         GPIO1 + 0x138
.equ GPIO_DATAOUT,        GPIO1 + 0x13c


.equ  GPIO_IRQSTATUS_SET_0, GPIO1 + 0x34
.equ  GPIO_RISINGDETECT,    GPIO1 + 0x148
.equ  GPIO_IRQSTATUS_0,  GPIO1 + 0x2c
.equ GPIO_IRQSTATUS_RAW_0, GPIO1 + 0x24
.equ GPIO_IRQSTATUS_1, GPIO1 + 0x30
.equ GPIO_LEVELDETECT1,  0x144 + GPIO1 


.equ  CM_PER_GPIO1, 0x44E000AC
.equ  GPIO1_MODULEMODE, 0x2
.equ  OPTFCLKEN_GPIO_1_GDBCLK, 0x00040000

//Control module



//pins está em um endereço arbitrário para a memória. Então seria algo como int **pins;
pins:
    .word conf_gpmc_a5    
    .word conf_gpmc_a6    
    .word conf_gpmc_a7    
    .word conf_gpmc_a8    
    .word conf_gpmc_ad2
    .word conf_gpmc_ad5
    .word conf_gpmc_ad7
    .word conf_gpmc_ad13
pins_end:

.text
.global gpio

gpio:

    /*
    parametros
    r0: offset em relação a tabela -- mux_pins
    r1: flag em relação à multiplexação --mux_pins
    r2: pino em relação ao amm335x_sitara -- define_output, blink
    r3: mandar sinal ou não
    */
   stmfd sp!, {r4-r6,lr}
  
    bl config_clock_gpio
  //  bl mux_pins
    bl define_output
    bl blink
   ldmfd sp!, {r4-r6,lr}

    bx lr



config_clock_gpio:

    
    ldr r4, =CM_PER_GPIO1
    ldr r5, [r4]  
    orr r5, #OPTFCLKEN_GPIO_1_GDBCLK
    orr r5, #GPIO1_MODULEMODE
    str r5, [r4]
    bx lr



mux_pins:
/*
r0 é o índice e vem por parametro
Se é 0, então não há offset
Se é 1, então o offeset em relação a base da tabela é 4
 */
    ldr r4, =pins    //Note que aqui é um ponteiro para um ponteiro   
    lsl r5, r0, #2  
    add r4, r4, r5      
//Note que é preciso desrreferenciar duas vezes
    ldr r5, [r4] 
    ldr r6, [r5]         
    orr r6, r1 // r1 é o parametro. Usuário precisará usar help para entender os parametros.         
    str r6, [r5]            
    bx lr


blink:
    cmp r3, #on
    bne pin_off

pin_on: 
    ldr r4, =GPIO_SETDATAOUT
    mov r5, #1
    lsl r5, r2
    str r5, [r4]
    bx lr

pin_off:
    ldr r4, =GPIO_CLEARDATAOUT
    mov r5, #0
    lsl r5, r2
    str r5, [r4]
    bx lr



define_output:
    ldr r4, =GPIO_OE
    ldr r5, [r4]
    mov r6, #1
    lsl r6, r2
    bic r5, r6
    str r5, [r4]
    bx lr
    
