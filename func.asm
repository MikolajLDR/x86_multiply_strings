section .text
global smul

smul:
    ; PROLOGUE
	push    ebp
    mov     ebp, esp

    sub     esp, 8

    push    ebx
    push    esi
    push    edi

    mov     eax, [ebp+8]    ; eax - result number
    mov     esi, [ebp+12]   ; esi - first string
    mov     edi, [ebp+16]   ; edi - second string

    push    esi             ; push address of first string to get length
    call    mystrlen        ; call the function
    add     esp, 4
    mov     [ebp-4], eax    ; [ebp-4] - lenght of first string

    push    edi             ; push address of first string to get length
    call    mystrlen        ; call the function
    add     esp, 4
    mov     [ebp-8], eax    ; [ebp-8] - lenght of first string

    mov     eax, [ebp-4]
    add     eax, [ebp-8]

    ; EPILOGUE
    pop     edi
    pop     esi
    pop     ebx

    mov     esp, ebp
    pop     ebp
    ret


mystrlen:
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