.equ UART0_THR,  			0x44E09000
.equ UART0_LSR,  			0x44E09014
.equ ASCII, 0x30

.equ buffer_max, 100

.data
line_feed: .asciz "\n\r"

.text
.global putCh
.global getCh
.global putString
.global getString

/*padrão seguido: r0, r1, r2, r3 - parametros
    retorno em r0
    registradores conservados - r4-r8
*/
putCh:
// r0 = char c
    stmfd sp!, {r4-r5, lr}      //salva registradores

//faz um pooling -- while (!(UART0_LSR & (1 << 5)));
pooling_putCh:
    ldr r4, =UART0_LSR   
    ldr r5, [r4]            
    lsr r5, #0x5     
    and r5, r5, #0x1
    cmp r5, #1
    bne pooling_putCh

    ldr r4, =UART0_THR
	str r0, [r4]
   

    ldmfd sp!, {r4-r5, lr}   //restaura os registradores
    bx lr




getCh:
	stmfd sp!, {r4-r5, lr} 
//faz um pooling -- while (!(UART1_LSR & (1 << 0)));
pooling_getCh:
    ldr r4, =UART0_LSR                                                                                              
    ldr r5, [r4]                                              
    and r5, r5, #0x1                                              
    cmp r5, #1                                              
    bne pooling_getCh                                              
                                              
	ldr r5, =UART0_THR                                              
	ldr r0, [r5]           //retorno em r0                                              
	ldmfd sp!, {r4-r5, lr} 
	bx lr 


getString:
    stmfd sp!, {r4-r6, lr} 

	/*
    r0 = char* buf
    */
    mov r5, r0   //char o endereço de char* buffer;
    mov r4, #0   //contador
loop_getString:
    cmp r4, #buffer_max
    beq return_get_string
    bl getCh 
    cmp r0, #0xA
    beq return_get_string
    cmp r0, #0xD
    beq return_get_string
    strb r0, [r5] 
    bl putCh
    add r5, #1  //buffer[i++]
    add r4, #1   
    b loop_getString


return_get_string:
    mov r4, #0
    strb r4, [r5]

    ldmfd sp!, {r4-r6, lr} 
    bx lr



putString:
 
    /*
    r0 = char* buffer
    */
    
    stmfd sp!, {r4-r6, lr} 
    mov r5, r0


loop_putString:
    ldrb r0, [r5]           //passando o char como parametro -- carrega um byte
    cmp r0, #0
    beq return_putString

    bl putCh
     
    add r5, #1
    b loop_putString

return_putString:
    ldmfd sp!, {r4-r6, lr} 
    bx lr

