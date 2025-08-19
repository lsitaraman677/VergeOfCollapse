extends AnimatedSprite2D

func get_boost_force(power, reposition=true):
	var mouse_pos = get_global_mouse_position() - global_position
	var ang = atan2(mouse_pos.y, mouse_pos.x)
	if reposition:
		rotation = ang
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if animation == 'paused':
			play('playing')
		return -Vector2(cos(ang), sin(ang)) * power
	play('paused')
	frame = 0
	return Vector2.ZERO
