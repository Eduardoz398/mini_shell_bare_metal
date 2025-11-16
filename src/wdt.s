


.equ WDT_WSPR, 0x44E35000 + 0x48
.equ WDT_WWPS, 0x44E35000 + 0x34



.text
.global watch_dog


watch_dog:
    stmfd sp!, {r4-r5, lr}
    ldr r4, =WDT_WSPR
    ldr r5, =0x0000AAAA
    str r5, [r4]

pooling_wdt1:
    ldr r4, =WDT_WWPS
    ldr r5, [r4]
    lsr r5, #0x4
    and r5, r5, #1
    cmp r5, #1
    beq pooling_wdt1

    ldr r4, =WDT_WSPR
    ldr r5, =0x00005555
    str r5, [r4]

pooling_wdt2:
    ldr r4, =WDT_WWPS
    ldr r5, [r4]
    lsr r5, #0x4
    and r5, r5, #1
    cmp r5, #1
    beq pooling_wdt2
    

	ldmfd sp!, {r4-r5, lr} 
    bx lr
/*
    void disable_wachdog()
{
	WDT_WSPR = 0x0000AAAA;
	while ((WDT_WWPS >> 4) & 1); // poll - verificanado se a escrita foi escrita(tanto é que esse registrador é read-only)
	WDT_WSPR = 0x00005555;
	while ((WDT_WWPS >> 4) & 1);
	/*
	manual says:
		o disable the timer, follow this sequence:
			1. Write XXXX AAAAh in WDT_WSPR.
			2. Poll for posted write to complete using WDT_WWPS.W_PEND_WSPR.
			3. Write XXXX 5555h in WDT_WSPR.
}
 */

