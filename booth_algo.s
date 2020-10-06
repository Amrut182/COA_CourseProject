	AREA DATA1, DATA
A EQU 0x0
q EQU 0x0 ;Q-1 bit
M EQU 0x5
Q EQU 0X6
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
	and R5, R2, 1; Getting Q0 bit
	and R6, R3, 1; Getting Q-1 bit 
	MOV R5, R5, lsl 1; left shift, 'Q0'_'0'
	add R5, R5, R6; 'Q0'_'Q-1'(got 2 bits as 1)	
	BX LR
label1
	sub R7, R10, 1; x = n - 1  
	MOV R8, 1; 1 value needed for next step
	MOV R5, R8, lsl R7; 1000
	MOV R2, R2, lsr 1; right shift Q
	add R2, R2, R5; right shifted Q + 1000  
	;BX LR
	MOV PC, R9
label2
	MOV R3, 1
	MOV PC, R9
	
label3
	MOV R2, R2, lsr 1; right shift Q
	MOV PC, R9

label4
	MOV R3, 0
	MOV PC, R9
AQq
	and R5, R1, 1; getting LSB of A
	MOV R1, R1, lsr 1
	cmp R5, 1
	MOV R6, R2; temp Q, for next steps lsb...
	;stmfd sp!, {list of registers }
	add R9, PC, 4 
	beq label1
	add R9, PC, 4 
	bne label3
	
	add R1, R1, R5
	and R5, R6, 1; getting LSB of Q
	cmp R5, 1
	MOV R9, 0
	MOV R9, PC
	beq label2
	MOV R9, PC
	bne label4
	;debug
	MOV R1, R1, lsl R10
	add R1, R1, R2
	MOV R1, R1, lsl 1
	add R1, R1, R3
	;
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
;endlabel
	;BX LR
__START
	MOV R1,A; Accumulator
	MVN R2,Q; Multiplier
	add R2, R2, 1
	;sub R2, R2, Q; Multiplier (for negative)
	MOV R3,q; Booth Bit
	MOV R4, M; Mulitplicand
	MOV R10, N; Count
;loop
	BL getTwoBit
	
	cmp R5, y
	beq ylabel
	 
	cmp R5, z
	beq zlabel
	
	BL AQq
	sub R10, R10, 1
	cmp R10, 0
	;bne loop
	;beq endlabel
LABEL B LABEL		
	END