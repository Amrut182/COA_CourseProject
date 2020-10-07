	AREA DATA1, DATA
A EQU 0x0000
q EQU 0x0 ;Q-1 bit
M EQU 0x5
Q EQU 0xFFFFFFFA; -6
N EQU 0X4
w EQU 0x00; ASR
x EQU 0x03; ASR
y EQU 0x02; A<--A-M
z EQU 0x01; A<--A+M	
t EQU 0x00; temp = 00
	
	AREA P01,CODE
			ENTRY 
	EXPORT __START		
getTwoBit
	and R5, R2, 1; Getting Q0 bit 1010 & 0001
	and R6, R3, 1; Getting Q-1 bit 
	MOV R5, R5, lsl 1; left shift, 'Q0'_'0'  
	add R5, R5, R6; 'Q0'_'Q-1'(got 2 bits as 1)	
	BX LR; 
	
AQq
	add R6, R10, 1; n+1
	MOV R1, R1, lsl R6; ls A by n+1
	;MOV R1, R1, lsl 30
	;MOV R1, R1, lsl 3
	MOV R2, R2, lsl 1; ls Q by 1
	add R8, R1, R2; A' = A append Q
	add R7, R8, R3; A'' = A' + q   = AQq
	MOV R7, R7, asr 1; Shifted AQq to right
	;MOV R8, R8, asr 1
	;MOV R2, R2, lsr 1
	BX LR
	
; A = A - M
ylabel
	MVN R4, R4
	add R4, R4, 1
	add R1, R1, R4
	BX LR
	
; A = A + M
zlabel
	add R1, R1, R4
	BX LR
bin
	MOV R9, 1; we need value 1 in register for next step
	MOV R9, R9 , lsl R10; 1 << bits 10000
	sub R9, R9, 1; (1 << bits - 1)  1111
	and R2, R2, R9; Q & (1 << bits - 1)
	MOV PC, R5
	
endlabel
	;LABEL B LABEL
	;BX LR
	B endlabel

__START
	MOV R1,A; Accumulator
	;MOV R2, Q; (+ve)
	
	;for -ve
	;MVN R2,Q; Multiplier (1s complement)
	;add R2, R2, 1; (2s complement)
	; (or)
	MOV R2, Q; Multiplier (-ve)
	MOV R3,q; Booth Bit
	MOV R4, M; Mulitplicand
	MOV R10, N; Count

	;RBIT R5, R2
	;and R5, R5, 1
	cmp R1, 0
	add R5, PC, 2; gettin address of next instruction pointer
	bmi bin

	cmp R2, 0
	add R5, PC, 2
	bmi bin
loop
	BL getTwoBit
	
	cmp R5, y; r5 is Qo_Q-1
	beq ylabel
	 
	cmp R5, z
	beq zlabel
	
	BL AQq
	
	sub R10, R10, 1
	cmp R10, 0
	
	bne loop
	beq endlabel
	
LABEL B LABEL		
	END