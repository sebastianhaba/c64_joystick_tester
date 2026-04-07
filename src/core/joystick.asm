joy_state_buffer:   .fill JOY_STATE_BUFFER_SIZE, $20 
joy_temp_state:     .byte 0


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