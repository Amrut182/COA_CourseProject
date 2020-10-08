	AREA DATA1,DATA
A EQU 0x0000; Accumulator
q EQU 0x0 ;Q-1 bit
M EQU 0x5; Multiplicand
Q EQU 0xFFFFFFFA; -6; Multiplier
N EQU 0X32; count
	AREA P01,CODE,READONLY
			ENTRY 
	EXPORT __START
__START
	MOV R1,#A; Accumulator
	MOV R2, #Q; Multiplier (-ve)
	MOV R3,#q; Booth Bit
	MOV R4, #M; Mulitplicand
	MOV R10, #N; Count
loop
	BL getTwoBit
	cmp R5, #2; r5 is Qo_Q-1
	add LR, PC, #4
	beq alabel; 02
	cmp R5, #1
	add LR, PC, #4
	beq zlabel; 01
	BL AQq
	sub R10, R10, #1
	cmp R10, #0
	add LR, PC, #2
	bne loop
	beq endlabel
getTwoBit
	and R5, R2, #1; Getting Q0 bit 1010 & 0001
	and R6, R3, #1; Getting Q-1 bit 
	MOV R5, R5, lsl #1; left shift, 'Q0'_'0'  
	add R5, R5, R6; 'Q0'_'Q-1'(got 2 bits as 1)	
	MOV PC, LR; 
AQq
	and R5, R1, #1; this ia a's lsb
	and R6, R2, #1; this is q's lsb
	MOV R3, R6; q-1=lsb of q
	MOV R2, R2, lsr #1; right shift q
	rbit R7, R2; 
	add R7, R7, R5; lsb of a is added to lsb of r7
	rbit R2, R7; q is reverse of r7
	MOV R1, R1, asr #1; right shift a
	MOV PC, LR;A=A-M
alabel
	MVN R4, R4
	add R4, R4, #1
	add R1, R1, R4
	MOV PC, LR;A=A-M
zlabel
	add R1, R1, R4
	MOV PC, LR
endlabel
	END