
RESET CODE 0x000
     goto main

ISR CODE 0x004
     goto isr_handler

MAIN CODE
isr_handler  ; interrupt code goes here

main

; your code goes here

;*****Set up the Constants**** 

STATUS  equ 03h      ;Address of the STATUS register
TRISA   equ 85h      ;Address of the tristate register for port A
PORTA   equ 05h      ;Address of Port A
FSR	equ 04h      ;Address of FSR register
USER1   equ 0Ch      ;Address for random stuff
USER2   equ 0Dh      ;Another address for random stuff

        
        ;****Turn the LED on**** 
       bsf STATUS,5
       movlw 00h
       movwf TRISA
       bcf STATUS,5
       movlw    02h     ;Turn the LED on by first putting
       movwf    PORTA   ;it into the w register and then
                         ;on the port 
                         
       ;*** Some nop's to implement a delay ***       
       nop
       nop
       nop
       nop
       nop
       nop
       nop
       
       ;****Delay finished, now turn the LED off**** 
       movlw   00h                     ;Turn the LED off by first putting
       movwf   PORTA                   ;it into the w register and then on
                                       ;the port 
                                       
       ;****Some random code testing all functions****
       CLRW		; STATUS = 28
       CLRF PORTA	; 

       movlw 7 		; W = 7
       ADDWF USER1,1 	; USER1 = 7, STATUS = 24
       ADDWF USER1,0 	; W = 14
       ANDWF USER1,0 	; W = 6
       ANDWF USER1,1 	; USER1 = 6
       COMF  USER1,0 	; W = 249
       COMF  USER1,1 	; USER1 = 249
       DECF  USER1,0 	; W = 248
       DECF  USER1,1 	; USER1 = 248
       INCF  USER2,0 	; W = 1
       INCF  USER2,1 	; USER2 = 1
       IORWF USER1,0 	; W = 249
       IORWF USER2,1 	; USER2 = 249
       MOVF  USER1,0 	; W = 248
       MOVF  USER1,1 	; nothing happens
       MOVWF USER2 	; USER2 = 248
       NOP 		; nothing happens
       RLF   USER2,1    ; USER2 = 240, STATUS = 25
       RLF   USER2,0 	; W = 225
       RRF   USER2,1 	; USER2 = 248, STATUS = 24
       RRF   USER2,0 	; W = 124
       SUBWF USER1,0 	; W = 124, STATUS = 25
       SUBWF USER2,1 	; USER2 = 124
       SWAPF USER1,1 	; USER1 = 143
       SWAPF USER1,0 	; W = 248
       XORWF USER2,1 	; USER2 = 132
       XORWF USER2,0 	; W = 124
       BCF   USER1,7 	; USER1 = 15
       BSF   USER1,4 	; USER1 = 31
       ANDLW D'123' 	; W = 120
       IORLW D'211' 	; W = 251
       MOVLW D'69' 	; W = 69
       SUBLW D'27' 	; W = 214, STATUS = 26
       XORLW D'205'     ; W = 27, STATUS = 26
       NOP
       
       ; testing of indirect addressing ;
       MOVLW USER1	; W = 12
       MOVWF FSR	; FSR = 12
       CLRW		; W = 0, STATUS = 30
       MOVF 0,0		; W = 31, STATUS = 26
       NOP
       
       
end
