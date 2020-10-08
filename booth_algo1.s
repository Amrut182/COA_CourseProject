	AREA DATA1,DATA
A EQU 0x00000000; Accumulator
q EQU 0x0 ;Q-1 bit
M EQU 0xFFFFFFF9; -7; Multiplicand, 
Q EQU 0xFFFFFFFA; -6; Multiplier
N EQU 0X20; count = 32
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
	cmp R5, #2; r5 is Qo_Q-1, alabel, A=A-M
	add LR, PC, #4
	beq alabel; 02, A=A-M
	cmp R5, #1; zlabel, A=A+M
	add LR, PC, #4
	beq zlabel; 01 A=A+M
	add LR, PC, #4
	BL AQq
	sub R10, R10, #1
	cmp R10, #0
	add LR, PC, #2
	bne loop
	beq endlabel
getTwoBit
	and R5, R2, #1; Getting Q0 bit i.e. LSB of Q
	and R6, R3, #1; Getting Q-1 bit 
	MOV R5, R5, lsl #1; left shift, 'Q0'_'0'  
	add R5, R5, R6; 'Q0'_'Q-1'(got 2 bits as 1)	
	MOV PC, LR; 
AQq
	and R5, R1, #1; this ia A's lsb
	and R6, R2, #1; this is Q's lsb
	MOV R3, R6; q-1=lsb of Q
	MOV R2, R2, lsr #1; right shift Q, MSB will then be 0
	MOV R5, R5, lsl #31; 0x80000000 or 0x0 (to add to MSB of Q)
	add R2, R2, R5; LSB of A is added to MSB of Q
	MOV R1, R1, asr #1; arithmetic right shift A
	MOV PC, LR
alabel
	sub R1, R1, R4
	MOV PC, LR;A=A-M
zlabel
	add R1, R1, R4
	MOV PC, LR
endlabel
	END