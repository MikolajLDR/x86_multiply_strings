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

; check if num1 == 0
is_num1_0:
    cmp     dword [ebp-4], 1
    jne     is_num2_0                   ; if len1 != 1 jump to is_num2_0
    mov     eax, [ebp+12]               ; eax = address of num1
    movzx   eax, byte [eax]             ; eax = num1[0]
    cmp     al, '0'
    jne     is_num2_0                   ; if num1[0] != '0' jump to is_num2_0
    mov     eax, [ebp+12]               ; return num1 ("0")
    jmp     the_end

; check if num2 == 0
is_num2_0:
    cmp     dword [ebp-8], 1
    jne     else                        ; if len2 != 1 jump to else
    mov     eax, [ebp+16]               ; eax = address of num2
    movzx   eax, byte [eax]             ; eax = num2[0]
    cmp     al, '0'
    jne     else                        ; if num2[0] != '0' jump to else
    mov     eax, [ebp+16]               ; return num2 ("0")
    jmp     the_end

; if neither numbers are zeros 
else:
    mov     ebx, [ebp-8]
    add     ebx, [ebp-4]
    mov     [ebp-12], ebx               ; [ebp-12] - length of result string

    mov     [ebp-16], ebx               ; [ebp-16] - index = result_len-1;
    dec     dword [ebp-16]
                                        ; [ebp-20] - index_loop
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

    mov     eax, [ebp-4]                ; eax = len1
    dec     eax                         ; eax--
    mov     [ebp-40], eax               ; i = eax
    jmp     for_loop_1
outer_loop:
    mov     dword [ebp-24], 0           ; carry = 0
    mov     eax, [ebp-16]               ; eax = index
    mov     [ebp-20], eax               ; index_loop = eax = index

    ; dig1 = num1[i] - '0'
    mov     edx, [ebp-40]               ; edx = i
    mov     eax, [ebp+12]               ; eax = address of num1
    add     eax, edx                    ; eax = address of current digit from num1
    movzx   eax, byte [eax]             ; eax = current digit from num1 in ascii
    sub     eax, '0'                    ; eax = current digit from num1 in int
    mov     [ebp-28], eax               ; dig1 = eax

    mov     eax, [ebp-8]                ; eax = len2
    dec     eax                         ; eax--
    mov     [ebp-44], eax               ; j = eax
    jmp     for_loop_2
inner_loop:
    ; dig2 = num2[j] - '0'
    mov     edx, [ebp-44]               ; edx = j
    mov     eax, [ebp+16]               ; eax = address of num2
    add     eax, edx                    ; eax = address of current digit from num2
    movzx   eax, byte [eax]             ; eax = current digit from num2 in ascii
    sub     eax, '0'                    ; eax = current digit from num2 in int
    mov     [ebp-32], eax               ; dig2 = eax
    ; mul_result = dig1*dig2
    mov     eax, [ebp-28]
    mov     ebx, [ebp-32]
    mul     ebx
    mov     [ebp-36], eax
    ; mul_result += result_string[index__loop];
    mov     edx, [ebp-20]               ; edx = index_loop
    mov     eax, [ebp+8]                ; eax = address of result_string 
    add     eax, edx                    ; eax = address of current digit in result_string
    mov     esi, eax                    ; esi = eax
    movzx   eax, byte [eax]             ; eax = result_string[index_loop]
    add     [ebp-36], eax               ; mul_result += eax
    ; mul_result += carry
    mov     eax, [ebp-24]
    add     [ebp-36], eax
    ; mul_result -= '0'
    sub     byte [ebp-36], '0'
    
    mov     eax, [ebp-36]
    aam
    mov     [ebp-24], ah                ; carry = mul_result/10
    mov     [esi], al                   ; result_string[index_j] = mul_result % 10
    add     dword [esi], '0'            ; result_string[index_j] += '0'

    dec     dword [ebp-20]              ; index_loop--
    dec     dword [ebp-44]              ; j--
for_loop_2:
    cmp     dword [ebp-44], 0
    jns     inner_loop                  ; if j>=0 jump to inner_loop
    
    ; result_string[index_j] += carry
    mov     edx, [ebp-20]               ; edx = index_loop
    mov     eax, [ebp+8]                ; eax = address of result_string
    add     eax, edx                    ; eax = address of current digit in result_string
    mov     ecx, [ebp-24]
    add     [eax], ecx

    dec     dword [ebp-16]              ; index--
    dec     dword [ebp-40]              ; i--
for_loop_1:
    cmp     dword [ebp-40], 0
    jns     outer_loop                  ; if i>=0 jump to outer_loop
    ; if (result_string[0] == '0') result_string++
    mov     eax, [ebp+8]
    movzx   eax, byte [eax]
    cmp     al, '0'
    jne     end
    inc     dword [ebp+8]

    ;====EPILOGUE====
end:
    mov     eax, [ebp+8]

the_end:
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