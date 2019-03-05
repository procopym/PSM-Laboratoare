
.include "m32def.inc"

; definirea unei constante
 .equ const		=	250 
 .equ LedRED = PB0
 .equ LedYellow=PB1
 .equ LEDGreen = PB2


; redefinirea registrilor
 .def tmpH  = r16
 .def tmpL  = r17
 .def aL 	= r18
 .def aH 	= r19

 .def flags = r2
 

.dseg	; segmentul de date
.org 0x63		; sa plaseze variabila pe adresa 0x63
myvar:	.byte 4
var2:	.byte 1

.cseg	; segmentul de cod 
.org	0x0000
	rjmp	RESET	; Salt neconditionat

.org	INT0addr	; External Interrupt0 Vector Address
	reti
.org	INT1addr	; External Interrupt1 Vector Address
	rjmp INT1_ISR

.org	INT2addr	; External Interrupt2 Vector Address
	reti
.org	OC2addr	    ; Output Compare2 Interrupt Vector Address
	reti 
.org	OVF2addr	; Overflow2 Interrupt Vector Address
	reti
.org	ICP1addr	; Input Capture1 Interrupt Vector Address
	reti
.org	OC1Aaddr	; Output Compare1A Interrupt Vector Address
	reti
.org	OC1Baddr	; Output Compare1B Interrupt Vector Address
	reti
.org	OVF1addr	; Overflow1 Interrupt Vector Address
	reti
.org	OC0addr	    ; Output Compare0 Interrupt Vector Address
	reti
.org	OVF0addr	; Overflow0 Interrupt Vector Address
	reti
.org	SPIaddr	     ; SPI Interrupt Vector Address
	reti
.org	URXCaddr	; USART Receive Complete Interrupt Vector Address
	reti
.org	UDREaddr	; USART Data Register Empty Interrupt Vector Address
	reti
.org	UTXCaddr	; USART Transmit Complete Interrupt Vector Address
	reti
.org	ADCCaddr	; ADC Interrupt Vector Address
	reti
.org	ERDYaddr	; EEPROM Interrupt Vector Address
	reti
.org	ACIaddr 	; Analog Comparator Interrupt Vector Address
	reti
.org    TWIaddr   ; Irq. vector address for Two-Wire Interface
	reti
.org	SPMRaddr	; Store Program Memory Ready Interrupt Vector Address
	reti

//---------------------------------------------------------------
INT1_ISR:    ;Subrutina de prelucrare a intreruperii
 		; comenzi pentru subruta data
	 reti

; Programul principal
//--------------------------------------------------------------	 
RESET:	 
     ldi tmpL, Low(RAMEND) 	; initializam stiva
	 out SPL, tmpL
	 ldi tmpH, High(RAMEND) 
	 out SPH, tmpH
 
	 CLR tmpL				;resetam tmpl
	 ;out DDRA, tmpL			; Setam ca intrare PORTA
	; ldi tmpL,  (1<<LedRED) |(1<<LedYellow)| (1<<LedGreen) 	
	 ; out DDRA, tmpL			; Setam ca intrare PORTD


	 ldi tmpL, 0xff			 	
	 out DDRC, tmpL		; Setam ca iesire PORTB	 
	 out DDRD, tmpL		; Setam ca iesire PORTC

	
 MAIN: ; programul principal

 	;PB*12
	clr tmpH
	in tmpL, PINB; citim date din PINB

	ldi tmpH, 12
	mul tmpL, tmpH
 	
	ldi tmpL, const
	sts 0x68, tmpL

	clr tmpH

	lds tmpL, 0x68

	;([M68h] - PB*12
	sub tmpL, r0
	sbc tmpH, r1

	ldi aL, 4

	LOOP:
		asr tmpH
		ror tmpL
		dec aL
		brne LOOP

	;([M68h] - PB*12)/16 
	out PORTC, tmpH
	out PORTD, tmpL

 	;cbi PORTB, LedGreen
	;cbi PORTB, LedRED
	;sbi PORTB, LedYellow
	
	;rcall delay	
	;rcall delay

	;sbi PORTB, LedGreen
	;sbi PORTB, LedRED
	;cbi PORTB, LedYellow


	;rcall delay
	;rcall delay

	;cbi PORTB, LedGreen
	;sbi PORTB, LedRED
	;sbi PORTB, LedYellow


	;lds tmpL, 0x63
    ;in tmpL, PINA	; citim datele din PINA	 
	;ldi tmpH, 6 ;incarcam const 5 	
	;muls tmpL, tmpH ; inmultim registrii
	
	
	;ldi aL, LOW(const1) ;incarcam octetul inferior al const 
	;ldi aH, High(const1);incarcam octetul superior al const 

	;ldi tmpL, LOW(const) ;incarcam const 400 in tmpL
	;ldi tmpH, High(const)

	;sub tmpL, r0; scadem din reg aL const
	;sbc tmpH, r1; scadem partea super cu transp
	
	;asr tmpH ; deplasam la dreapta cu o pozitie aritmetic
	;ror tmpL ; deplasam oct inf
	;asr tmpH ; deplasam la dreapta cu o pozitie aritmetic
	;ror tmpL ; deplasam oct inf	asr tmpH ; deplasam la dreapta cu o pozitie aritmetic
	;asr tmpH ; deplasam la dreapta cu o pozitie aritmetic
	;ror tmpL ; deplasam oct inf


	;out PORTA, tmpH
	;out PORTD, tmpL

	nop

	RJMP MAIN



delay:
	ldi tmpl, 250
 extloop:
 	ldi tmpH, 250
	intloop:
 	nop
	nop
	nop
	dec tmpH
	brne intloop
	dec tmpL
	brne extloop
	ret
