section .text
global smul
smul:
	push    ebp
    mov     ebp, esp

    sub     esp, 8

    push    ebx
    push    esi
    push    edi

    ; [ebp+8] - result string
    ; [ebp+12] - first number string
    ; [ebp+16] - second number string

    mov     eax, [ebp+12]               ; eax = address of first string to get length
    call    strlen                      ; call the function
    mov     esi, eax                    ; esi - length of first number

    mov     eax, [ebp+16]               ; eax = address of second string to get length
    call    strlen                      ; call the function
    mov     [ebp-4], eax                ; [ebp-4] - length of second number

; check if num1 == 0
is_num1_0:
    cmp     dword esi, 1
    jne     is_num2_0                   ; if len1 != 1 jump to is_num2_0
    mov     eax, [ebp+12]               ; eax = address of num1
    movzx   eax, byte [eax]             ; eax = num1[0]
    cmp     al, '0'
    jne     is_num2_0                   ; if num1[0] != '0' jump to is_num2_0
    mov     eax, [ebp+12]               ; return num1 ("0")
    jmp     the_end

; check if num2 == 0
is_num2_0:
    cmp     dword [ebp-4], 1
    jne     else                        ; if len2 != 1 jump to else
    mov     eax, [ebp+16]               ; eax = address of num2
    movzx   eax, byte [eax]             ; eax = num2[0]
    cmp     al, '0'
    jne     else                        ; if num2[0] != '0' jump to else
    mov     eax, [ebp+16]               ; return num2 ("0")
    jmp     the_end

; if neither numbers are zeros 
else:
    mov     ebx, [ebp-4]
    add     ebx, esi
    mov     edi, ebx                    ; edi - length of result string

    mov     [ebp-8], ebx                ; [ebp-8] - index = result_len-1;
    dec     dword [ebp-8]
                                        ; esi - carry
                                        ; dl - dig1
                                        ; bl - dig2
                                        ; cl - i
                                        ; ch - j

; filling result string with '0'

    mov     cl, 0                       ; cl - fill string with '0' loop iterator
    jmp     fill_loop
zero:
    mov     eax, [ebp+8]
    add     al, cl
    mov     byte [eax], '0'
    inc     cl
fill_loop:
    movzx   ecx, cl
    cmp     ecx, edi                    ; string length
    jl      zero                        ; jump if eax < length 
    mov     edx, edi   
    mov     eax, [ebp+8]
    add     eax, edx
    mov     byte [eax], 0               ; set \0 at string's end

; multiplying
    mov     ecx, esi
    dec     cl                          ; i = len1-1
    jmp     for_loop_1
outer_loop:
    mov     dword esi, 0                ; carry = 0

    ; dig1 = num1[i] - '0'
    mov     edx, [ebp+12]               ; ebx = address of num1
    add     dl, cl                      ; ebx = address of current digit from num1
    movzx   edx, byte [edx]             ; ebx = current digit from num1 in ascii
    sub     edx, '0'                    ; ebx = current digit from num1 in int
                                        ; dl = dig1
    mov     ch, [ebp-4]
    dec     ch                          ; j = len2-1
    jmp     for_loop_2
inner_loop:
    ; dig2 = num2[j] - '0'
    mov     ebx, [ebp+16]               ; ebx = address of num2
    add     bl, ch                      ; ebx = address of current digit from num2
    movzx   ebx, byte [ebx]             ; ebx = current digit from num2 in ascii
    sub     ebx, '0'                    ; ebx = current digit from num2 in int
                                        ; bl = dig2
    ; mul_result = dig1*dig2
    mov     al, dl
    mul     bl
    movzx   edi, ax
    ; mul_result += result_string[index];
    mov     eax, [ebp-8]                ; eax = index
    mov     ebx, [ebp+8]                ; ebx = address of result_string 
    add     ebx, eax                    ; ebx = address of current digit in result_string

    mov     eax, ebx
    movzx   eax, byte [eax]             ; eax = result_string[index]
    add     edi, eax                    ; mul_result += eax
    add     edi, esi                    ; mul_result += carry
    sub     edi, '0'                    ; mul_result -= '0'
    
    mov     eax, edi
    aam
    movzx   esi, ah                     ; carry = mul_result/10
    mov     [ebx], al                   ; result_string[index_j] = mul_result % 10
    
    add     dword [ebx], '0'            ; result_string[index_j] += '0'

    dec     dword [ebp-8]               ; index--
    dec     ch                          ; j--

for_loop_2:
    cmp     ch, 0
    jns     inner_loop                  ; if j>=0 jump to inner_loop
    
    ; result_string[index_j] += carry
    mov     edx, [ebp-8]                ; edx = index_loop
    mov     eax, [ebp+8]                ; eax = address of result_string
    add     eax, edx                    ; eax = address of current digit in result_string
    mov     edx, esi
    add     [eax], edx

    mov     eax, [ebp-4] 
    add     [ebp-8], eax                ; index--
    dec     dword [ebp-8]
    dec     cl                          ; i--
for_loop_1:
    cmp     cl, 0
    jns     outer_loop                  ; if i>=0 jump to outer_loop
    ; if (result_string[0] == '0') result_string++
    mov     eax, [ebp+8]
    movzx   eax, byte [eax]
    cmp     al, '0'
    jne     end
    inc     dword [ebp+8]

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

    mov     ebx, eax

lop1:
    mov     dl, [ebx]
    inc     ebx
    test    dl, dl
    jnz     lop1
    dec     ebx
    sub     ebx, eax
    mov     eax, ebx

    ret 