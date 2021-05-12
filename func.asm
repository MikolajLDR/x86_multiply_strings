section .text
global mul_digits

mul_digits:
	push    ebp
    mov     ebp, esp
    ;sub     esp, 4
    ;push    edi
    ;push    esi

    mov     eax, [ebp+8]
    ;mov     edi, [ebp+16]

    ;mov     [ebp−4], edi
    ;add     [ebp−4], esi
    add     eax, [ebp+12]

    ;pop     esi
    ;pop     edi
    mov     esp, ebp
    pop     ebp
    ret
