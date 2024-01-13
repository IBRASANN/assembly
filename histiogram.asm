org 100h

.stack 100
 .data

string db 100 dup('$')
histogram db 26 dup (0) 
colors db 26 dup (0)
letters db 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
curs db 2
rr db 20
row db 0
.code
mov ax,@data
mov ds,ax

  mov cx, 15 
  mov si, 0
  mov bl, 00011111b

  L1:mov [colors+si], bl
  add bl,00010000b
  inc si  
  loop L1
  
  mov cx, 11 
  mov si, 0
  mov bl, 00011111b
  
  L2:mov byte [colors+si+15], bl
  add bl,00010000b
  inc si  
  loop L2
 
mov cx,100
mov si,0
 
read:

mov ah,1
int 21h

cmp al, 0Dh
je display_histogram
cmp al, 'a'
jb not_char
cmp al, 'z'
ja not_char

mov string[si],al

sub al,'a'
mov ah,0
push si
mov si,ax

inc histogram[si]

pop si

inc si

loop read





display_histogram:
  mov ah, 0   
  mov al, 03h 
  int 10h
   
  mov cx, 26 
  mov si, 0  
  
  L11:
  
  or [histogram+si],0
  jnz L22
  jz L33
  
  L22:
  push cx
  call print_hist
  pop cx
  add curs,3
  L33:
  inc si
  dec cx
  jnz L11
  jz end1


proc print_hist  
    
  mov ah, 02h 
  mov bh, 0 
  mov dh, 24
  mov dl, curs    
  int 10h    
  
  mov al, [histogram+si]
  mov ah, 0
  mov bl, 10
  div bl
  push ax
  add al, 30h
  mov ah, 0eh
  int 10h
  pop ax
  
  mov al,ah
  add al, 30h
  mov ah, 0eh
  int 10h
  
    
  mov ah, 02h 
  mov bh, 0 
  mov dh, 22
  mov dl, curs    
  int 10h    
 
  mov al, [letters+si]
  mov ah, 0eh
  int 10h
  
  mov cl, [histogram+si]
  mov ch, 0
  
  mov bl,rr
  mov row,bl
    
step:
    push cx
    
    mov al, 1
	mov bh, 0
	mov bl, [colors+si]
	mov cx, 2  
	mov dl, curs
	mov dh, row
	mov bp, " "
	mov ah, 13h
	int 10h
	
    sub row,1 
    pop cx      
loop step

ret
print_hist endp 
    
    
not_char:
 jmp end1

end1:
 end


