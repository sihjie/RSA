INCLUDE Irvine32.inc

code PROTO,e:WORD,N:WORD
decode PROTO,d:WORD,N:WORD
findN PROTO,aa:WORD,bb:WORD
findkey PROTO,e:WORD,N:WORD
takemod PROTO,q:WORD

main  EQU start@0 ;
.data
	title1   BYTE   "Choose mode(1 for code||2 for decode)",0
	title2   BYTE   "please input a character:",0
	title3   BYTE   "please input code:",0
	title4a   BYTE   "please input p(<100 Prime):",0
	title4b   BYTE   "please input q(<100 Prime):",0
	title4c   BYTE   "N is:",0
	title4d   BYTE   "please input N:",0
	title5   BYTE   "please input key(",0
	title5a   BYTE   "):",0
	title5b   BYTE   "decode key is:",0
	title5c   BYTE   "please input decode key:",0
	key WORD ?
	dekey WORD ?
	Num WORD ?
	R WORD ?
	a WORD ?
	b WORD ?
	char WORD ?
.code
main PROC
	
	choose:
	mov eax,0
	mov edx,0
    mov edx , OFFSET title1		;將title1存進edx中
    call WriteString	;輸出title1 "Choose mode(1 for code||2 for decode)"
	call ReadInt	;讀取一個32位元的有號十進位整數，傳到eax中
	cmp eax,1	;若輸入為1，跳至L3
	je L3
	cmp eax,2	;若輸入為2，則跳至L4
	je L4
	jmp L5		;跳至L5
	
	L3:
	mov eax,YELLOW	+ (BLACK SHL 4)       ;設定為黑底黃字
    call SetTextColor
	mov edx , OFFSET title4a	;將title4a存進edx中
    call WriteString	;輸出title4a "please input p(<100 Prime):"
	call ReadInt
	mov [a],ax		;將輸入的值p存進a
	mov edx , OFFSET title4b	
    call WriteString	;輸出title4b "please input q(<100 Prime):"
	call ReadInt
	mov [b],ax		;將輸入的值q存進b
	invoke findN,[a],[b]	;呼叫findN
	mov eax,0
	mov eax,YELLOW + (BLACK SHL 4)       
    call SetTextColor
	mov edx , OFFSET title5
    call WriteString	;輸出title5 "please input key("
	mov ax,[R]	;將R的值放進ax
	call WriteDec	;輸出ax的值
	mov edx , OFFSET title5a
    call WriteString	;輸出title5a  "):"
	mov eax,0
	call ReadInt	;將輸入的數字存進eax
	mov [key],ax	;將ax的值存進key
	invoke findkey,[key],[R]	;呼叫findkey
	mov eax,YELLOW + (BLACK SHL 4)       
    call SetTextColor		;將輸出設為黑底黃字
	mov edx , OFFSET title2
    call WriteString	;輸出title2 "please input a character:"
	mov eax,0
	mov edx,0
	call ReadChar	;將輸入的字元存進eax
	mov ah,0
	mov [char],ax	;將ax存入char
	call WriteChar	;輸出字元
	call Crlf 
	mov eax,WHITE + (BLACK SHL 4)       ;設回原本設定
    call SetTextColor
	mov eax,0
	mov ax,[char]	;將char存入ax
	invoke code,[key],[Num]		;呼叫code
	call WriteDec	;輸出ax的值
	call Crlf
	jmp L5	;跳至L5
	
	L4:
	mov edx , OFFSET title4d
    call WriteString	;輸出title4d  "please input N:"
	call ReadInt	;將輸入的值讀進eax
	mov [Num],ax	;將ax的值存進Num
	mov eax,0
	mov edx , OFFSET title5c
    call WriteString	;輸出title5c "please input decode key:"
	call ReadInt	;將輸入的值讀進eax
	mov [key],ax	;將ax的值存進key
	mov edx , OFFSET title3
    call WriteString	;輸出title3 "please input code:"
	mov eax,0
	mov edx,0
	call ReadInt	;將輸入的值讀進eax
	invoke decode,[key],[Num]	;呼叫decode
	call WriteChar		;輸出字元
	call Crlf
	
	L5:
		jmp choose	;跳至choose
main ENDP

takemod PROC,
	q:WORD
	
	push bx		;先保留bx的值
	mov bx,q	;將q的值存進bx
	div bx	;將ax除以bx
	mov ax,dx	;將餘數放在ax
	
	pop bx	;取得原先存的bx值
Exit_proc:
	ret
takemod ENDP

findN PROC,
	aa:WORD,
	bb:WORD
	
	mov eax,0
	mov ebx,0
	mov ax,aa	;將aa的值存入ax
	mov bx,bb	;將bb的值存入bx
	sub ax,1	;ax=ax-1
	sub bx,1	;bx=bx-1
	mul bx		;ax=ax*bx=(aa-1)*(bb-1)
	mov [R],ax	;將ax的值存進R
	
	mov eax,0
	mov ax,aa
	mov bx,bb
	mul bx
	mov [Num],ax	;將aa*bb的值存進Num
	mov eax,WHITE + (BLACK SHL 4)       ;設回原本設定
    call SetTextColor
	mov ax,[Num]	;將Num的值放進ax
	mov edx , OFFSET title4c	
    call WriteString	;輸出title4c "N is:"
	call WriteDec	;輸出eax的值 (aa*bb)
	call Crlf	;換行
Exit_proc:
	ret
findN ENDP

findkey PROC,
	e:WORD,
	N:WORD
	
	mov ecx,0	
	mov ebx,0
	mov edx,0

	L6:
		add ecx,1	;ecx+=1
		mov eax,0
		mov ax,cx	;將cx的值放入ax
		mov bx,N	;將N的值放進bx
		mul ebx		;eax=eax*ebx
		add eax,1	;eax=eax+1
		mov bx,e	;將e的值存進bx
		div ebx		;eax=eax/bx
		cmp edx,0	
		ja L6	;若餘數大於0則跳至L6
	mov [dekey],ax	;將商存進dekey
	mov eax,WHITE + (BLACK SHL 4)       ;設回原本設定
    call SetTextColor
	mov edx , OFFSET title5b	
    call WriteString	;輸出title5b "decode key is:"
	mov ax,[dekey]	
	call WriteDec	;輸出dekey的值
	call Crlf
Exit_proc:
	ret
findkey ENDP

code PROC,
	e:WORD,
	N:WORD
	
	mov ecx,0
	mov bx,ax	;將ax的值存進bx
	mov cx,e	;將e的值存進cx
	sub cx,1	;將cx值減1
L1:
	mul bx		;ax=ax*bx
L2:	
	invoke takemod,N
	cmp ax,N	;比較ax和N
	ja L2	;若大於則跳至L2

loop L1		;跳至L1迴圈
	
Exit_proc:
	ret
code ENDP

decode PROC,
	d:WORD,
	N:WORD
	
	mov ecx,0
	mov bx,ax	;將ax的值存進bx
	mov cx,d	;將d的值存進cx
	sub cx,1	;將cx的值減1
L1:
	mul bx		;ax=ax*bx
L2:	
	invoke takemod,N 
	cmp ax,N	;比較ax和N
	ja L2	;若大於N則跳至L2
	
loop L1		;跳至L1迴圈

	
Exit_proc:
	ret
decode ENDP
END main
