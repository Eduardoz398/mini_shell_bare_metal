//Interrupt
.equ INTCPS,  0x48200000
.equ INTC_MIR_SET3, INTCPS + 0xEC
.equ INTC_CONTROL, INTCPS + 0x48
.equ INTC_MIR_CLEAR3,  INTCPS + 0xE8


.data

clear_screen: .ascii "\033[2J\033[H"
clear_screen_len = . - clear_screen


.text
.global ISR_Handler
.global main

//setenv autoload no && setenv ipaddr 192.168.1.2 && setenv serverip 192.168.1.1 && tftp 0x80000000 appGpio.bin && go 0x80000000

main:
    
   bl watch_dog
   bl clear
   mov r0, #0
   mov r1, #0x7
   mov r2, #21
   mov r3, #1
   bl gpio
 
shell:
    mov r0, #'$'
    bl putCh
    bl getCh
    b shell

ISR_Handler:
   bx lr


clear:
    stmfd sp!, {lr}
    ldr r0, =clear_screen
    mov r1, #7
    bl putString
    ldmfd sp!, {lr}
    bx lr






