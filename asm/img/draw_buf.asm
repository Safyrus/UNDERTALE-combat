draw_packet_buffer:
    @buf  = tmp
    @mmc5 = tmp+2
    @prev = tmp+2
    @size = tmp+4
    @flag = tmp+5

    ; change RAM bank
    ; LDA #VAR_RAM_BNK
    ; STA mmc5_banks+0
    ; STA MMC5_RAM_BNK
    ; X = background_index
    LDA background_index
    TAX
    PHA

    ; draw high priority packets
    mov @flag, #$40
    JSR @draw_packet_buffer_1
    ; if no high priority packet has been found
    PLA
    CMP background_index
    BNE :+
        ; draw low priority packets
        mov @flag, #$00
        JSR @draw_packet_buffer_1
    :

    ; @buf,@prev = packet_buffer
    LDA #<packet_buffer
    STA @buf+0
    STA @prev+0
    LDA #>packet_buffer
    STA @buf+1
    STA @prev+1
    ; while true
    @defrag:
        ; if @buf >= packet_buffer_end
        LDA @buf+1
        CMP packet_buffer_end+1
        blt :+
        LDA @buf+0
        CMP packet_buffer_end+0
        blt :+
            JMP @defrag_end
        :
        ; get size
        LDY #$00
        LDA (@buf), Y
        ; if size = $FF
        CMP #$FF
        BEQ @defrag_erase
        @defrag_packet:
            ; size = (size*2)+3
            ASL
            add #$03
            STA @size
            ; for y from 0 to size
            for_y @defrag_copy, #0
                ;
                LDA (@buf), Y
                STA (@prev), Y
            to_y_inc @defrag_copy, @size
            ; @buf += size
            add_A2ptr @buf, @size
            ; @prev += size
            add_A2ptr @prev, @size
            JMP @defrag
        ; else
        @defrag_erase:
            ; @buf++
            inc_16 @buf
            JMP @defrag
    @defrag_end:

    ; packet_buffer_end -= packet_buffer_counter
    sub_A2ptr packet_buffer_end, packet_buffer_counter+0
    LDA packet_buffer_end+1
    sub packet_buffer_counter+1
    STA packet_buffer_end+1
    ;
    RTS



@draw_packet_buffer_1:
    ; get packet pointer
    sta_ptr @buf, packet_buffer
    ;
    LDA #$00
    STA packet_buffer_counter+0
    STA packet_buffer_counter+1

    ; for packet in packet_buffer
    @while:
        ; if @buf >= packet_buffer_end
        LDA @buf+1
        CMP packet_buffer_end+1
        blt :+
        LDA @buf+0
        CMP packet_buffer_end+0
        blt :+
            JMP @draw_end
        :
        ; get size
        LDY #$00
        LDA (@buf), Y
        AND #$BF
        STA @size
        ; if (size & $40) ^ flag == 0
        LDA (@buf), Y
        AND #$40
        EOR @flag
        BEQ :+
            JMP @else
        :
        ; background_limit - background_index
        LDA #PACKET_DRAW_LIMIT
        sub background_index
        ; if (background_limit - background_index) < 0 or (background_limit - background_index) >= size
        BPL :+
            JMP @else
        :
        CMP @size
        bge :+
            JMP @else
        :
            ; @mmc5 = (ppu_adr & 0x3FF) + MMC5_EXP_RAM
            INY
            LDA (@buf), Y
            AND #$03
            ORA #>MMC5_EXP_RAM
            STA @mmc5+1
            INY
            LDA (@buf), Y
            STA @mmc5+0

            ; size += 3
            LDA #$03
            add @size
            STA @size
            ; copy ppu packet
            LDY #$00
            @copy_lo:
                ; background[X] = packet[Y]
                LDA (@buf), Y
                STA background, X
                ; erase packet[Y]
                LDA #$FF
                STA (@buf), Y
                ; X++
                INX
            to_y_inc @copy_lo, @size
            ; close ppu packet
            LDA #$00
            STA background, X
            STX background_index

            ; buf += size
            add_A2ptr @buf, @size
            add_A2ptr packet_buffer_counter, @size
            ; size -= 3
            LDA @size
            sub #$03
            TAY
            STA @size
            ; copy mmc5 tiles
            DEY
            @copy_hi:
                ; mmc5[Y] = packet[Y]
                LDA (@buf), Y
                STA (@mmc5), Y
                ; erase packet[Y]
                LDA #$FF
                STA (@buf), Y
            to_y_dec @copy_hi, #-1

            ; @buf += size
            add_A2ptr @buf, @size
            add_A2ptr packet_buffer_counter, @size
            ; while
            JMP @while

        ; else
        @else:
            ; buf += (size*2)+3
            LDA @size
            ASL
            add #$03
            add_A2ptr @buf
            ; while
            JMP @while
    @draw_end:
    RTS
