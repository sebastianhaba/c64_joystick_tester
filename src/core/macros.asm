// Prints the null-terminated string at text_addr to the screen at the specified position (pos_x, pos_y).
.macro print(text_addr, pos_x, pos_y) {
    .var screen_ram_addr = SCREEN + (pos_y * 40) + pos_x
    ldx #0
print_loop:
    lda text_addr,x
    beq print_done
    sta screen_ram_addr,x
    inx
    jmp print_loop

print_done:
}

// Appends the text at text_addr to the joy_state_buffer, starting from the beginning of the buffer.
// Set the Y register to the desired offset in the buffer before calling this macro.
.macro append_to_buffer(text_addr) {
    ldx #0
append_loop:
    lda text_addr,x
    beq append_done
    sta joy_state_buffer,y
    inx
    iny
    jmp append_loop

append_done:
}

// Clears the joy_state_buffer by filling it with space characters (screencode $20) and null-terminating it at the end.
.macro clear_state_buffer() {
    .var last_index     = JOY_STATE_BUFFER_SIZE - 2    
    ldx #0
clear_loop:
    lda #$20
    sta joy_state_buffer,x
    inx
    cpx #last_index
    bne clear_loop
    inx
    lda #0
    sta joy_state_buffer,x
}

// Sets the screen border color to the specified color value.
.macro border_color(color) {
    lda #color
    sta SCREEN_BORDER
}

// Reads the byte at value_addr and prints its bits as '1' or '0' on the screen at the specified position (pos_x, pos_y).
.macro print_bits(value_addr, pos_x, pos_y) {
    .var addr = SCREEN + (pos_y * 40) + pos_x
    lda value_addr
    sta joy_temp_state
    ldx #7
print_bits_loop:
    and #%00000001
   
    beq print_bits_zero
        lda #$31        // screencode '1'
        jmp print_bits_store
    print_bits_zero:
        lda #$30        // screencode '0'
    print_bits_store:
        sta addr,x
        lsr joy_temp_state
        lda joy_temp_state
        dex
        bpl print_bits_loop
}