	AREA DATA1, DATA
A EQU 0x0000; Accumulator
q EQU 0x0 ;Q-1 bit
M EQU 0x5; Multiplicand
Q EQU 0xFFFFFFFA; -6; Multiplier
N EQU 0X32; count
	AREA P01,CODE
			ENTRY 
	EXPORT __START		
getTwoBit
	and R5, R2, 1; Getting Q0 bit 1010 & 0001
	and R6, R3, 1; Getting Q-1 bit 
	MOV R5, R5, lsl 1; left shift, 'Q0'_'0'  
	add R5, R5, R6; 'Q0'_'Q-1'(got 2 bits as 1)	
	BX LR; 
;AQq

;	BX LR
	
; A = A - M
ylabel
	sub R1, R1, R4
	BX LR
; A = A + M
zlabel
	add R1, R1, R4
	BX LR
endlabel
	B endlabel
__START
	MOV R1,A; Accumulator
	MOV R2, Q; Multiplier (-ve)
	MOV R3,q; Booth Bit
	MOV R4, M; Mulitplicand
	MOV R10, N; Count
loop
	BL getTwoBit
	cmp R5, 2; r5 is Qo_Q-1
	beq ylabel; 02
	cmp R5, 1
	beq zlabel; 01
	;BL AQq
	sub R10, R10, 1
	cmp R10, 0
	bne loop
	beq endlabel
LABEL B LABEL		
	END