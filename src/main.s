//Interrupt
.equ INTCPS,  0x48200000
.equ INTC_MIR_SET3, INTCPS + 0xEC
.equ INTC_CONTROL, INTCPS + 0x48
.equ INTC_MIR_CLEAR3,  INTCPS + 0xE8

.equ PRM_RSTCTRL, 0x44E00F00 + 0x0




//.data
//
//clear_screen: .asciz "\033[2J\033[H"
//clear_screen_len = . - clear_screen
//teste: .asciz "Isso eh um teste"

.text
.global ISR_Handler
.global main
.global swi_handler_

//setenv autoload no && setenv ipaddr 192.168.1.2 && setenv serverip 192.168.1.1 && tftp 0x80000000 appGpio.bin && go 0x80000000


/*
   
    essa vai ser uma das funções do terminal  - reboot - via swi
 
*/

main:
    
   bl watch_dog
 //  bl clear
   mov r0, #1
   mov r1, #0x7
   mov r2, #22
   mov r3, #1

   bl gpio
 
   bl shell

ISR_Handler:
   bx lr


//clear:
//    stmfd sp!, {lr}
//    ldr r0, =clear_screen
//    bl putString
//    ldmfd sp!, {lr}
//    bx lr


swi_handler_:
    ldr r0, =PRM_RSTCTRL
    bic r1, #(1<<1)
    str r1, [r0]
    bx lr







