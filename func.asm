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

    mov     eax, [ebp+8]        ; eax - result number
    mov     esi, [ebp+12]       ; esi - first number
    mov     edi, [ebp+16]       ; edi - second number

    ;====PROGRAM====
    push    esi                 ; push address of first string to get length
    call    strlen              ; call the function
    add     esp, 4
    mov     [ebp-4], eax        ; [ebp-4] - lenght of first number

    push    edi                 ; push address of second string to get length
    call    strlen              ; call the function
    add     esp, 4
    mov     [ebp-8], eax        ; [ebp-8] - length of second number

    mov     ebx, [ebp-8]
    add     ebx, [ebp-4]
    mov     [ebp-12], ebx       ; [ebp-12] - length of result string

    mov     dword [ebp-16], 0   ; [ebp-16] - incremented index (int a in C)
                                ; [ebp-20] - index in result (int index in C)

                                ; [ebp-24] - carry
                                ; [ebp-28] - current digit from first number
                                ; [ebp-32] - current digit from second number
                                ; [ebp-36] - outer loop iterator
                                ; [ebp-40] - inner loop iterator
                                ; [ebp-44] - result of multiply with carry (sum in C)

; filling result string with '0'

    mov     dword [ebp-48], 0   ; [ebp-48] - fill string with '0' loop iterator
    jmp     fill_loop
zero:
    mov     edx, [ebp-48]
    mov     eax, [ebp+8]
    add     eax, edx
    mov     byte [eax], '0'
    inc     dword [ebp-48]
fill_loop:
    mov     eax, [ebp-48]       ; eax - iterator
    cmp     eax, [ebp-12]       ; string length
    jl      zero                ; jump if eax < length 
    mov     edx, [ebp-12]
    mov     eax, [ebp+8]
    add     eax, edx
    mov     byte [eax], 0       ; set \0 at string's end

; multiplying

    ; for (int i=len1-1; i>=0; i--)
    mov     eax, [ebp-4]        ; eax - first string length
    dec     eax                 ; eax -= 1 (bo indexy od 0)
    mov     [ebp-36], eax       ; outer loop iterator = eax
    jmp     multiply
outer_loop:
    ; index = a
    mov     eax, [ebp-16]       ; eax = a
    mov     [ebp-20], eax       ; index = eax
    ; carry = 0 in C
    mov     dword [ebp-24], 0   ; carry = 0
    ; n1 = num1[i] - '0'
    mov     edx, [ebp-36]       ; edx = outer loop iterator (i in C)
    mov     eax, esi            ; eax = first number address
    add     eax, edx            ; eax += edx (eax = address of current char in string)
    movzx   eax, byte [eax]     ; eax = current char in first string
    sub     eax, '0'            ; eax -= '0' (ascii to int)
    mov     [ebp-28], eax       ; current digit from first number = eax
    ; for (int j=len2-1; j>=0; j--)
    mov     eax, [ebp-8]        ; eax - first string length
    dec     eax                 ; eax -= 1 (bo indexy od 0)
    mov     [ebp-40], eax       ; inner loop iterator = eax
    jmp     add_carry
mul_digits:
    ; n2 = num2[j] - '0'
    mov     edx, [ebp-40]
    mov     eax, edi
    add     eax, edx
    movzx   eax, byte [eax]     ; eax = current char in second string
    sub     eax, '0'
    mov     [ebp-32], eax
    ; sum = n1*n2
    mov     eax, [ebp-28]
    imul    eax, [ebp-32]
    mov     [ebp-44], eax
    ; sum += result_string[index]
    mov     edx, [ebp-20]       ; edx = index in result
    mov     eax, [ebp+8]        ; eax = address of result string
    add     eax, edx            ; eax = address of current char in result string
    movzx   eax, byte [eax]     ; eax = current char in result string
    add     [ebp-44], eax       ; sum += eax
    ; sum += carry
    mov     eax, [ebp-24]       ; eax = carry
    add     [ebp-44], eax       ; sum += eax
    ; sum -= '0'
    sub     dword [ebp-44], '0'       ; sum -= '0' (ascii to int)
    ; carry = sum/10 (*0x66666667/2^31/2^2 -> 0x66666667 ~= 2^33/5 -> 2^33/5/2^31/2^2 -> 1/10)
    ;mov     ecx, [ebp-44]       ; ecx = sum
    ;mov     edx, 0x66666667     ; edx = 0x66666667 ~= 2^33/5
    ;mov     eax, ecx            ; eax = ecx = sum
    ;mul     edx                 ; edx *= eax
    ;sar     edx, 2              ; edx /= 2^2
    ;mov     eax, ecx            ; eax = ecx = sum
    ;sar     eax, 31             ; eax /= 2^31 
    ;sub     edx, eax            ; edx -= eax
    ;mov     eax, edx            ; eax = edx
    ;mov     [ebp-24], eax       ; carry = eax

    mov     eax, [ebp-44]
    mov     edx, 0
    mov     ebx, 10
    div     ebx
    mov     [ebp-24], eax
    ;mov     ecx, [ebp-20]
    ;mov     eax, [ebp+8]
    ;add     eax, ecx
    ;mov     eax, edx

    ; result_string[index] = sum % 10
    ;mov     ecx, [ebp-44]
    ;mov     edx, 0x66666667
    ;mov     eax, ecx
    ;mul     edx
    ;sar     edx, 2
    ;mov     eax, ecx
    ;sar     eax, 31
    ;sub     edx, eax
    ;mov     eax, edx
    ;sal     eax, 2
    ;add     eax, edx
    ;add     eax, eax
    ;sub     ecx, eax
    ;mov     edx, ecx
    mov     ecx, [ebp-20]
    mov     eax, [ebp+8]
    add     eax, ecx
    mov     byte [eax], dl
    ; result_string[index] += '0'
    mov     edx, [ebp-20]
    mov     eax, [ebp+8]
    add     eax, edx
    movzx   eax, byte [eax]
    lea     ecx, [eax+48]
    mov     edx, [ebp-20]
    mov     eax, [ebp+8]
    add     eax, edx
    mov     edx, ecx
    mov     byte [eax], dl
    ; index++
    inc     dword [ebp-20]

    dec     dword [ebp-40]
add_carry:
    cmp     dword [ebp-40], 0
    jns     mul_digits
    ; result_string[index] += carry
    mov     edx, [ebp-20]
    mov     eax, DWORD [ebp+8]
    add     eax, edx
    movzx   eax, byte [eax]
    mov     edx, eax
    mov     eax, DWORD [ebp-24]
    lea     ecx, [edx+eax]
    mov     edx, DWORD [ebp-20]
    mov     eax, DWORD [ebp+8]
    add     eax, edx
    mov     edx, ecx
    mov     byte [eax], dl

    ;a++
    inc     dword [ebp-16]
    ;index++
    inc     dword [ebp-20]

    dec     dword [ebp-36]
multiply:
    cmp     dword [ebp-36], 0
    jns     outer_loop

    mov     eax, [ebp+8]


; removing zeros from end

; reverse string

    ;====EPILOGUE====

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