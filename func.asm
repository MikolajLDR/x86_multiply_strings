section .text
global smul
smul:
    ;====PROLOGUE====
	push    ebp
    mov     ebp, esp

    sub     esp, 48

    push    ebx
    push    esi
    push    edi

    ; [ebp+8] - result number
    ; [ebp+12] - first number
    ; [ebp+16] - second number

    ;====PROGRAM====
    push    dword [ebp+12]              ; push address of first string to get length
    call    strlen                      ; call the function
    add     esp, 4
    mov     [ebp-4], eax                ; [ebp-4] - lenght of first number

    push    dword [ebp+16]              ; push address of second string to get length
    call    strlen                      ; call the function
    add     esp, 4
    mov     [ebp-8], eax                ; [ebp-8] - length of second number

    mov     ebx, [ebp-8]
    add     ebx, [ebp-4]
    mov     [ebp-12], ebx               ; [ebp-12] - length of result string

    mov     [ebp-16], ebx               ; [ebp-16] - index = result_len-1;
    dec     dword [ebp-16]
                                        ; [ebp-20] - index_j
                                        ; [ebp-24] - carry
                                        ; [ebp-28] - dig1
                                        ; [ebp-32] - dig2
                                        ; [ebp-36] - mul_result
                                        ; [ebp-40] - i
                                        ; [ebp-44] - j

; filling result string with '0'

    mov     dword [ebp-48], 0           ; [ebp-48] - fill string with '0' loop iterator
    jmp     fill_loop
zero:
    mov     edx, [ebp-48]
    mov     eax, [ebp+8]
    add     eax, edx
    mov     byte [eax], '0'
    inc     dword [ebp-48]
fill_loop:
    mov     eax, [ebp-48]               ; eax - iterator
    cmp     eax, [ebp-12]               ; string length
    jl      zero                        ; jump if eax < length 
    mov     edx, [ebp-12]   
    mov     eax, [ebp+8]
    add     eax, edx
    mov     byte [eax], 0               ; set \0 at string's end


; multiplying

    mov     eax, [ebp-4]
    sub     eax, 1
    mov     [ebp-40], eax
    jmp     for_loop_1
outer_loop:
    mov     dword [ebp-24], 0
    mov     eax, [ebp-16]
    mov     [ebp-20], eax
    mov     edx, [ebp-40]
    mov     eax, [ebp+12]
    add     eax, edx
    movzx   eax, byte [eax]
    sub     dword eax, '0'
    mov     [ebp-28], eax
    mov     eax, [ebp-8]
    sub     eax, 1
    mov     [ebp-44], eax
    jmp     for_loop_2
inner_loop:
    mov     edx, [ebp-44]
    mov     eax, [ebp+16]
    add     eax, edx
    movzx   eax, byte [eax]
    sub     eax, 48
    mov     [ebp-32], eax
    mov     eax, [ebp-28]
    imul    eax, [ebp-32]
    mov     [ebp-36], eax
    mov     edx, [ebp-20]
    mov     eax, [ebp+8]
    add     eax, edx
    mov     esi, eax
    movzx   eax, byte [eax]
    movsx   eax, al
    add     [ebp-36], eax
    mov     eax, [ebp-24]
    add     [ebp-36], eax
    sub     byte [ebp-36], '0'
    
    mov     eax, [ebp-36]
    aam
    mov     [ebp-24], ah
    mov     [esi], al
    add     dword [esi], '0'

    sub     dword [ebp-20], 1
    sub     dword [ebp-44], 1
for_loop_2:
    cmp     dword [ebp-44], 0
    jns     inner_loop
    mov     edx, [ebp-20]
    mov     eax, [ebp+8]
    add     eax, edx
    movzx   eax, byte [eax]
    mov     edx, eax
    mov     eax, [ebp-24]
    lea     ecx, [edx+eax]
    mov     edx, [ebp-20]
    mov     eax, [ebp+8]
    add     eax, edx
    mov     edx, ecx
    mov     byte [eax], dl
    sub     dword [ebp-16], 1
    sub     dword [ebp-40], 1
for_loop_1:
    cmp     dword [ebp-40], 0
    jns     outer_loop
    mov     eax, [ebp+8]
    movzx   eax, byte [eax]
    cmp     al, '0'
    jne     end
    add     dword [ebp+8], 1

    ;====EPILOGUE====
end:
    mov     eax, [ebp+8]
    
    pop     edi
    pop     esi
    pop     ebx

    mov     esp, ebp
    pop     ebp
    ret

strlen:
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp+8]

lop1:
    mov     dl, [eax]
    inc     eax
    test    dl, dl
    jnz     lop1
    dec     eax
    sub     eax, [ebp+8]

    pop     ebp
    ret 