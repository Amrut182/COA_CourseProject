	AREA DATA1, DATA
VAR1 EQU 0x0001
VAR2 EQU 0x0008
RES EQU 0x00130
	AREA P01,CODE
		ENTRY 
	EXPORT __START
__START
	; START
	; Initialising
	MOV R3,0x0000; A
	MOV R1,0x0101; M
	MOV R2,0x1010; Q
	MOV R4,0x0004; Count = n
	;LDR R3,=num1; 32bit
;num1 DCD 0x12345678
	LDR R5, = VAR1
	LDR R6, = VAR2
	MOV R1,RES
LABEL B LABEL 
	END