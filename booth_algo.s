	AREA DATA1, DATA; blah
A EQU 0X0000
q EQU 0x0011 ;Q-1 bit
M EQU 0x0101
Q EQU 0X1111
N EQU 0X0004
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
	MOV R7, R5, lsl 1; left shift, 'Q0'_'0'
	add R8, R7, R6; 'Q0'_'Q-1'(got 2 bits as 1)	
	BX LR
	
__START
	MOV R1,A; Accumulator
	MOV R2,Q; Multiplier
	MOV R3,q; Booth Bit
	MOV R4, M; Mulitplicand
	BL getTwoBit
LABEL B LABEL		
	END