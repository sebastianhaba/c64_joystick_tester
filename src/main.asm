BasicUpstart2(main)

.label SCREEN           = $0400
.label SCREEN_BORDER    = $d020
.label SCREEN_CLEAR     = $e544

.label JOY2_STATE   = $dc00
.label JOY2_IDLE    = %01111111
.label JOY2_UP 	    = %00000001
.label JOY2_DOWN	= %00000010
.label JOY2_LEFT	= %00000100
.label JOY2_RIGHT	= %00001000
.label JOY2_FIRE	= %00010000

.const JOY_STATE_BUFFER_SIZE = 17
.const COLOR_LIGHT_BLUE      = 14
.const COLOR_RED             = 2

// Prints the null-terminated string at text_addr to the screen at the specified position (pos_x, pos_y).
.macro print(text_addr, pos_x, pos_y) {
    .var addr = SCREEN + (pos_y * 40) + pos_x
    ldx #0
print_loop:
    lda text_addr,x
    beq print_done
    sta addr,x
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

.macro border_color(color) {
    lda #color
    sta SCREEN_BORDER
}

.macro print_bits(value_addr, pos_x, pos_y) {
    .var addr = SCREEN + (pos_y * 40) + pos_x
    lda value_addr
    ldx #7
print_bits_loop:
    and #%11111111
    lsr
    bcc print_bits_zero
        lda #$31        // screencode '1'
        jmp print_bits_store
    print_bits_zero:
        lda #$30        // screencode '0'
    print_bits_store:
        sta addr,x
        lda value_addr
        dex
        bpl print_bits_loop
}

main:
    // Clear the screen and print the header, footer, and initial state text
    jsr SCREEN_CLEAR
    print(text_header, 12, 2)
    print(text_footer, 9, 22)
    print(text_state, 2, 5)

main_loop:
    // Clear the joy_state_buffer before updating it with the current state
    clear_state_buffer()

    jsr check_joy2_state
    print(joy_state_buffer, 9, 5)

    jmp main_loop

check_joy2_state:
    ldy #0
    lda JOY2_STATE
    print_bits(JOY2_STATE, 5, 7)
    cmp #JOY2_IDLE
    beq joy2_idle
        jmp check_joy2_up
    joy2_idle:
        append_to_buffer(text_joy_idle)

    check_joy2_up:
        lda JOY2_STATE
        and #JOY2_UP
        beq joy2_up
            jmp check_joy2_down
        
        joy2_up:
            ldy #0
            append_to_buffer(text_joy_up)
    
    check_joy2_down:
        lda JOY2_STATE
        and #JOY2_DOWN
        beq joy2_down   
            jmp check_joy2_left

        joy2_down:
            ldy #0
            append_to_buffer(text_joy_down)  

    check_joy2_left:
        lda JOY2_STATE
        and #JOY2_LEFT
        beq joy2_left   
            jmp check_joy2_right

        joy2_left:
            append_to_buffer(text_joy_left) 

    check_joy2_right:
        lda JOY2_STATE
        and #JOY2_RIGHT
        beq joy2_right   
            jmp check_joy2_fire

        joy2_right:
            append_to_buffer(text_joy_right)   

    check_joy2_fire:
        lda JOY2_STATE
        and #JOY2_FIRE
        beq joy2_fire   
            border_color(COLOR_LIGHT_BLUE)
            jmp check_joy2_done

        joy2_fire:
            append_to_buffer(text_joy_fire)   
            border_color(COLOR_RED)

    check_joy2_done:
        rts

text_header:
    .encoding "screencode_mixed"
    .text "joystick tester"
    .byte $0

text_footer:
    .encoding "screencode_mixed"
    .text "sebastian haba (2026)"
    .byte $0

text_state:
    .encoding "screencode_mixed"
    .text "state:"
    .byte $0

text_joy_idle:
    .encoding "screencode_mixed"
    .text "idle"
    .byte $0

text_joy_up:
    .encoding "screencode_mixed"
    .text "up "
    .byte $0

text_joy_down:
    .encoding "screencode_mixed"
    .text "down "
    .byte $0

text_joy_left:
    .encoding "screencode_mixed"
    .text "left "
    .byte $0    

text_joy_right:
    .encoding "screencode_mixed"
    .text "right "
    .byte $0    

text_joy_fire:
    .encoding "screencode_mixed"
    .text "fire"
    .byte $0

joy_state_buffer: .fill JOY_STATE_BUFFER_SIZE, $20 