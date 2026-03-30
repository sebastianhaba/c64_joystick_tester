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

.label SPRITE0_POS_X    = $d000
.label SPRITE0_POS_Y    = $d001
.label SPRITE0_COLOR    = $d027
.label SPRITE0_POINTER  = $07f8
.label SPRITE0_IDLE_POS_X = 173
.label SPRITE0_IDLE_POS_Y = 151

.label SPRITE1_POS_X    = $d002
.label SPRITE1_POS_Y    = $d003
.label SPRITE1_COLOR    = $d028
.label SPRITE1_POINTER  = $07f9

.label SPRITE2_POS_X    = $d004
.label SPRITE2_POS_Y    = $d005
.label SPRITE2_COLOR    = $d029
.label SPRITE2_POINTER  = $07fa

.label SPRITE3_POS_X    = $d006
.label SPRITE3_POS_Y    = $d007
.label SPRITE3_COLOR    = $d02a
.label SPRITE3_POINTER  = $07fb

.label SPRITE4_POS_X    = $d008
.label SPRITE4_POS_Y    = $d009
.label SPRITE4_COLOR    = $d02b
.label SPRITE4_POINTER  = $07fc

.label SPRITE_ENABLE    = $d015

.const JOY_STATE_BUFFER_SIZE = 17
.const COLOR_LIGHT_BLUE      = 14
.const COLOR_RED             = 2
.const COLOR_GREEN           = 5

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

main:
    // Clear the screen and print the header, footer, and initial state text
    jsr SCREEN_CLEAR
    print(text_header, 12, 2)
    print(text_footer, 9, 22)
    print(text_joy2_addr, 2, 5)
    print(text_state, 2, 7)

    // Sprite 0 initialization
    lda #SPRITE0_IDLE_POS_X
    sta SPRITE0_POS_X

    lda #SPRITE0_IDLE_POS_Y
    sta SPRITE0_POS_Y

    lda #$84
    sta SPRITE0_POINTER

    lda #COLOR_RED
    sta SPRITE0_COLOR

    // Sprite 1 initialization
    lda #160
    sta SPRITE1_POS_X

    lda #140
    sta SPRITE1_POS_Y

    lda #$80
    sta SPRITE1_POINTER

    lda #COLOR_GREEN
    sta SPRITE1_COLOR

    // Sprite 2 initialization
    lda #184
    sta SPRITE2_POS_X

    lda #140
    sta SPRITE2_POS_Y

    lda #$81
    sta SPRITE2_POINTER

    lda #COLOR_GREEN
    sta SPRITE2_COLOR

    // Sprite 3 initialization
    lda #160
    sta SPRITE3_POS_X

    lda #161
    sta SPRITE3_POS_Y

    lda #$82
    sta SPRITE3_POINTER

    lda #COLOR_GREEN
    sta SPRITE3_COLOR

    // Sprite 4 initialization
    lda #184
    sta SPRITE4_POS_X

    lda #161
    sta SPRITE4_POS_Y

    lda #$83
    sta SPRITE4_POINTER

    lda #COLOR_GREEN
    sta SPRITE4_COLOR

    // Enable sprites
    lda #%00011111
    sta SPRITE_ENABLE
    
main_loop:
    // Clear the joy_state_buffer before updating it with the current state
    clear_state_buffer()

    print_bits(JOY2_STATE, 9, 5)

    jsr check_joy2_state
    print(joy_state_buffer, 9, 7)

    jmp main_loop

// Checks the state of the joystick connected to port 2 and updates the joy_state_buffer with the corresponding text for each state.
check_joy2_state:
    ldy #0
    lda JOY2_STATE
    
    cmp #JOY2_IDLE
    beq joy2_idle
        jmp check_joy2_up
    joy2_idle:
        append_to_buffer(text_joy_idle)
        lda #SPRITE0_IDLE_POS_X
        sta SPRITE0_POS_X

        lda #SPRITE0_IDLE_POS_Y
        sta SPRITE0_POS_Y

    check_joy2_up:
        lda JOY2_STATE
        and #JOY2_UP
        beq joy2_up
            jmp check_joy2_down
        
        joy2_up:
            ldy #0
            append_to_buffer(text_joy_up)
            lda #SPRITE0_IDLE_POS_Y
            sec
            sbc #21
            sta SPRITE0_POS_Y
    
    check_joy2_down:
        lda JOY2_STATE
        and #JOY2_DOWN
        beq joy2_down   
            jmp check_joy2_left

        joy2_down:
            ldy #0
            append_to_buffer(text_joy_down)  
            lda #SPRITE0_IDLE_POS_Y
            clc
            adc #21
            sta SPRITE0_POS_Y

    check_joy2_left:
        lda JOY2_STATE
        and #JOY2_LEFT
        beq joy2_left   
            jmp check_joy2_right

        joy2_left:
            append_to_buffer(text_joy_left) 
            lda #SPRITE0_IDLE_POS_X
            sec
            sbc #23
            sta SPRITE0_POS_X


    check_joy2_right:
        lda JOY2_STATE
        and #JOY2_RIGHT
        beq joy2_right   
            jmp check_joy2_fire

        joy2_right:
            append_to_buffer(text_joy_right)   
            lda #SPRITE0_IDLE_POS_X
            clc
            adc #23
            sta SPRITE0_POS_X   
            
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

text_joy2_addr:
    .encoding "screencode_mixed"
    .text "$dc00: "
    .byte $0

joy_state_buffer: .fill JOY_STATE_BUFFER_SIZE, $20 

joy_temp_state: .byte 0

*=$2000 "Sprites"
.import binary "assets\gfx\sprites.bin"