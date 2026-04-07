BasicUpstart2(main)

#import "core/constants.asm"
#import "core/macros.asm"
#import "core/texts.asm"
#import "core/joystick.asm"

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

*=$2000 "Sprites"
.import binary "assets\gfx\sprites.bin"