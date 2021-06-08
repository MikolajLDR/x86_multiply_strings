; edx       length of first number
; ecx       length of second number
; ebx       pointer when multiplying
; edi       second pointer when multiplying
; esi       pointer for result when multiplying

; [ebp+8]   address of result string
; [ebp+12]  address of first number string
; [ebp+16]  address of second number string

section .text
    global  smul

smul:
    ; Prologue
    push    ebp
    mov     ebp, esp

    push    esi
    push    edi
    push    ebx

    ; Change first number to int and find end
    xor     edx, edx
    mov     ebx, [ebp+12]
first_num_loop:
    mov     al, [ebx+edx]
    sub     al, '0'
    xchg    al, [ebx+edx]
    inc     edx
    test    al, al
    jnz     first_num_loop
    dec     edx

    ; Change second number to int and find end
    xor     ecx, ecx
    mov     edi, [ebp+16]
second_num_loop:
    mov     al, [edi + ecx]
    sub     al, '0'
    xchg    al, [edi + ecx]
    inc     ecx
    test    al, al
    jnz     second_num_loop
    dec     ecx

    ; Main muliplication
    xor     eax, eax            ; eax = 0
    mov     ebx, edx            ; ebx = edx = długość pierwszej liczby
    push    edx                 ; edx czyli długość pierwszej liczby wrzucam na stack
    mov     esi, [ebp+8]        ; esi = adres początku wyniku
    add     esi, ebx            ; esi = adres początku wyniku + długość pierwszej liczby
    inc     esi                 ; esi++
    add     ebx, [ebp+12]       ; ebx = adres końca pierwszej liczby
mul_num_by_dig:
    dec     ebx                 ; ebx-- 
    dec     esi                 ; esi-- 
    mov     dl, [ebx]           ; current digit from first number

    ; Single multiplication
    add     esi, ecx            ; esi = adres w wyniku
    mov     edi, ecx            ; edi = ecx = długość drugiej liczby
    add     edi, [ebp+16]       ; edi = adres końca drugiej liczby
mul_dig_by_dig:
    dec     edi
    dec     esi
    mov     al, [edi]           ; current digit from second number
    mul     dl                  ; ax = al * dl

    ; Adjust to decimal digit
    add     al, [esi]
    aam

    ; Save calculated digit and decide what to do next
    add     [esi-1], ah
    mov     [esi], al
    cmp     edi, [ebp+16]
    jne     mul_dig_by_dig      ; jump if entire second number was not multiplied

    cmp     ebx, [ebp+12]
    jne     mul_num_by_dig      ; jump if entire first number was not multiplied

    ; Remove 0 before result if present
    mov     eax, [ebp+8]
    mov     dl, [eax]
    test    dl, dl
    jnz     change_to_ascii
    inc     eax
    dec     ecx
    ; If result begins with 00 it was sth big * 0 and should be 0
    mov     dl, [eax]
    test    dl, dl
    jnz     change_to_ascii
    dec     eax
    add     byte [eax], '0'
    pop     edx
    jmp     end

    ; Change result to ascii
change_to_ascii:
    mov     esi, eax
    pop     edx
    add     esi, edx
    add     esi, ecx
digit_to_ascii:
    dec     esi
    add     byte [esi], '0'
    cmp     esi, eax
    jg      digit_to_ascii

end:
    pop     ebx
    pop     edi
    pop     esi
    pop     ebp
    ret
