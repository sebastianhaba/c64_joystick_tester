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

.label JOY_STATE_BUFFER_SIZE = 17
.label COLOR_LIGHT_BLUE      = 14
.label COLOR_RED             = 2
.label COLOR_GREEN           = 5