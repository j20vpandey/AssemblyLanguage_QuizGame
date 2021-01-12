; pandey_vishnu.ClassProject_QuizGame.asm
; Class Project		Vishnu Pandey
; Quiz game			12/02/2020
; ************************************************************************************************************

INCLUDE Irvine32.inc

.data
;Questions and answers
qsn1 BYTE "a. Which two 32-bit registers are known as extended index registers?",0
ans1 BYTE "   1. SI, DI		2. EAX, EBX		3. ESI, EDI		4. EBP, ESP",0
qsn2 BYTE "b. What is the name of the lowest 8 bits of the EDX register?",0
ans2 BYTE "   1. DL		2. DH		3. DX		4. none of the above",0
qsn3 BYTE "c. How much memory can be addressed in Real-address mode?",0
ans3 BYTE "   1. 640 K		2. 1 MB		3. 16 MB	4. 4 GB",0
qsn4 BYTE "d. How much memory can be addressed in Protected mode?",0
ans4 BYTE "   1. 640 K		2. 1 MB		3. 16 MB	4. 4 GB",0
qsn5 BYTE "e. Which type of I/O device uses the 16550 UART chip?",0
ans5 BYTE "   1. USB port		2. printer port		3. serial port		4. parallel port",0
qsn6 BYTE "f. What is the name of the bus architecture commonly used with Pentium processors?",0
ans6 BYTE "   1. PCI		2. ISA		3. EISA		4. RAM-BUS",0
qsn7 BYTE "g. Within the CPU, all calculations and logic operations take place inside the ___________ .",0
ans7 BYTE "   1. registers		2. ALU		3. CU		4. MBU",0
qsn8 BYTE "h. Which flag is set when an unsigned value is too large to fit into a destination operand?",0
ans8 BYTE "   1. Sign		2. Carry		3. Overflow		4. Auxiliary Carry",0
qsn9 BYTE "i. Which register is known as a loop counter?",0
ans9 BYTE "   1. EAX		2. EBX		3. ECX		4. EDX",0
qsn10 BYTE "j. Which type of RAM is typically used for cache memory?",0
ans10 BYTE "   1. static RAM		2. dynamic RAM		3. CMOS RAM		4. Video RAM",0

;Array of questions and answers
qsnArray DWORD qsn1, qsn2, qsn3, qsn4, qsn5, qsn6, qsn7, qsn8, qsn9, qsn10
ansArray DWORD ans1, ans2, ans3, ans4, ans5, ans6, ans7, ans8, ans9, ans10
correctAns DWORD 3,1,2,4,3,1,2,2,3,1

;Messages
wcMsg BYTE "Please enter the correct answer (1-4).",0
correctMsg BYTE "Correct answer.",0
wrongMsg BYTE "Wrong answer.",0
scoreMsg1 BYTE "Your score is ",0
scoreMsg2 BYTE " out of ",0
rvAnsMsg BYTE "Press enter to review the answer.",0
ansMsg BYTE "  Correct answer is ",0
replayMsg BYTE "Press enter to play again.",0

;PROTO
RunQuiz PROTO, arrayQsn : PTR DWORD, arrayAns : PTR DWORD, ansCorrect : PTR DWORD, arrayLen : DWORD
ReviewAns PROTO, arrayQsn : PTR DWORD, arrayAns : PTR DWORD, ansCorrect : PTR DWORD, arrayLen : DWORD

.code
main proc
	;Start of game
	call Clrscr
	mov edx, offset wcMsg
	call writestring
	call crlf
	call crlf
	INVOKE RunQuiz, ADDR qsnArray, ADDR ansArray, ADDR correctAns, lengthof ansArray

	;Score display
	call Clrscr
	mov edx, offset scoreMsg1
	call writestring
	mov ebx,eax
	call writeint
	mov edx, offset scoreMsg2
	call writestring
	mov eax, lengthof correctAns
	call writeint
	call crlf
	mov edx, offset rvAnsMsg
	call writestring
	call readInt

	;Review the answer
	call Clrscr
	INVOKE ReviewAns, ADDR qsnArray, ADDR ansArray, ADDR correctAns, lengthof ansArray

	;Replay a game
	mov edx, offset replayMsg
	call writestring
	call readInt
	call main	;recursion

	exit
main endp

RunQuiz PROC, arrayQsn : PTR DWORD, arrayAns : PTR DWORD, ansCorrect : PTR DWORD, arrayLen : DWORD
	mov edi, arrayQsn
	mov esi, arrayAns
	mov ebx, ansCorrect
	mov ecx, arrayLen
	mov eax, 0
L1:
	mov edx, [edi]
	call writestring
	call crlf
	mov edx, [esi]
	call writestring
	call crlf

	push eax
	call readInt
	
	.IF eax == [ebx]
		mov edx, offset correctMsg
		call writestring
		pop eax
		inc eax
	.ELSE
		mov edx, offset wrongMsg 
		call writestring
		pop eax
	.ENDIF

	call crlf
	add edi, type qsnArray
	add esi, type ansArray
	add ebx, type correctAns
	loop L1
	
	ret
RunQuiz endp

ReviewAns PROC, arrayQsn : PTR DWORD, arrayAns : PTR DWORD, ansCorrect : PTR DWORD, arrayLen : DWORD
	mov edi, arrayQsn
	mov esi, arrayAns
	mov ebx, ansCorrect
	mov ecx, arrayLen
L1:
	mov edx, [edi]
	call writestring
	call crlf
	mov edx, [esi]
	call writestring
	call crlf
	mov edx, offset ansMsg
	call writestring
	mov eax, [ebx]
	call writeint
	call crlf
	call crlf
	add edi, type qsnArray
	add esi, type ansArray
	add ebx, type correctAns
	loop L1
	
	ret
ReviewAns endp

end main