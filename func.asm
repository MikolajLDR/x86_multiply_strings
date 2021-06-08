; edx       length of first number
; ecx       length of second number
; ebx       first number pointer
; edi       second number pointer
; esi       result pointer

; [ebp+8]   address of result string
; [ebp+12]  address of first number string
; [ebp+16]  address of second number string

section .text
    global  smul

smul:
    push    ebp
    mov     ebp, esp

    push    esi
    push    edi
    push    ebx

    ; Change first number to int
    xor     edx, edx
    mov     ebx, [ebp+12]
first_to_int:
    mov     al, [ebx+edx]
    sub     al, '0'
    xchg    al, [ebx+edx]
    inc     edx
    test    al, al
    jnz     first_to_int
    dec     edx                 ; edx = length of first number

    ; Change second number to int
    xor     ecx, ecx
    mov     edi, [ebp+16]
second_to_int:
    mov     al, [edi+ecx]
    sub     al, '0'
    xchg    al, [edi+ecx]
    inc     ecx
    test    al, al
    jnz     second_to_int
    dec     ecx                 ; ecx = length of second number

    ; Muliply numbers
    xor     eax, eax            ; eax = 0
    mov     ebx, edx            ; ebx = length of first number
    push    edx
    mov     esi, [ebp+8]        ; esi = address of result string
    add     esi, ebx            ; esi = address of result string + length of first number
    inc     esi
    add     ebx, [ebp+12]       ; ebx = address of last digit in first number
outer_loop:
    add     esi, ecx
    dec     esi
    dec     ebx                 ; move to next digit in first number
    mov     dl, [ebx]           ; dl = current digit from first number

    mov     edi, ecx            ; edi = length of second number
    add     edi, [ebp+16]       ; edi = address of last digit in second number
inner_loop:
    dec     esi
    dec     edi                 ; move to next digit in second number
    mov     al, [edi]           ; al = current digit from second number
    mul     dl                  ; ax = al * dl

    add     al, [esi]
    aam

    add     [esi-1], ah
    mov     [esi], al

    cmp     edi, [ebp+16]
    jne     inner_loop          ; jump if entire second number was not multiplied

    cmp     ebx, [ebp+12]
    jne     outer_loop          ; jump if entire first number was not multiplied

    ; Remove 0 from result beggining
    mov     eax, [ebp+8]
    mov     dl, [eax]
    test    dl, dl
    jnz     finish
    inc     eax
    dec     ecx
    ; If result begins with 00 then result = 0
    mov     dl, [eax]
    test    dl, dl
    jnz     finish
    dec     eax
    add     byte [eax], '0'
    pop     edx
    jmp     end

    ; Changing ints in result to ascii
finish:
    mov     esi, eax
    pop     edx
    add     esi, edx
    add     esi, ecx
change_to_ascii:
    dec     esi
    add     byte [esi], '0'
    cmp     esi, eax
    jg      change_to_ascii

end:
    pop     ebx
    pop     edi
    pop     esi
    pop     ebp
    ret
