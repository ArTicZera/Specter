[BITS    16]

;SI = Char Bitmap
;AL = Color
DrawChar:
        pusha

        call    SetupCursor

        mov     ah, 0x0C

        push    word [cursorX]
        push    word [cursorY]

        shl     word [cursorX], 0x03
        shl     word [cursorY], 0x03

        mov     cx, [cursorX]
        mov     dx, [cursorY]

        mov     bx, [si]

        jmp     .loopX

        .loopY:
                inc     si
                mov     bx, [si]

                ;Go back to where started
                ;BUT in the next line
                mov     cx, [cursorX]
                inc     dx

                mov     di, HFONT
                add     di, [cursorY]

                cmp     dx, di
                jae     .end
        
        .loopX:
                ;0 -> Continue without drawing
                ;1 -> Draw the pixel
                test    bx, 0x80
                jz      .continue

                int     0x10

        .continue:
                ;Next position
                inc     cx

                ;Move bits to left
                shl     bx, 0x01

                ;WFONT + StartX = FinalX
                mov     di, WFONT
                add     di, [cursorX]

                ;If it reaches the FinalX
                ;Then go to the next line
                cmp     cx, di
                jae     .loopY

                jmp     .loopX

.end:
        pop     word [cursorY]
        pop     word [cursorX]

        inc     word [cursorX]

        call    SetupCursor

        popa

        ret

;--------------------------------

;SI = String
;AL = Color
PrintString:
        pusha

        xor     bx, bx
        xor     ah, ah

        .getCharBMP:
                push    ax

                mov     al, [si]
                shl     ax, 0x03

                mov     bx, ax

                pop     ax

        .printChar:
                push    si

                mov     si, ProggyFont
                add     si, bx

                call    DrawChar

                pop     si

        .nextChar:
                inc     si
                mov     bx, [si]

                cmp     bl, 0x0F
                je      .endLine

                cmp     bl, 0x00
                jne     .getCharBMP

                jmp     PrintString.end

        .endLine:
                mov     word [cursorX], 0x00
                inc     word [cursorY]

                jmp     .nextChar

PrintString.end:
        popa

        ret

;--------------------------------

SetupCursor:
        cmp     word [cursorX], 40
        jae     .nextCursorLine

        jmp     SetupCursor.end

        .nextCursorLine:
                mov     word [cursorX], 0x00
                inc     word [cursorY]

SetupCursor.end:
        ret

cursorX: dw 0x00
cursorY: dw 0x00
