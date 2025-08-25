extends ProgressBar

var float_value = 1.0
var activated = true

func _ready():
	var fill = get_theme_stylebox("fill").duplicate()
	fill.bg_color = Color(0, 1, 0, 0.5)
	add_theme_stylebox_override("fill", fill)
	var bar = get_theme_stylebox("background").duplicate()
	bar.bg_color = Color(1, 1, 1, 0.25)
	add_theme_stylebox_override("background", bar)
	
func _process(dt):
	value = float_value
	var mouse_pos = get_global_mouse_position() - get_parent().global_position
	$AnimatedSprite2D.rotation = atan2(mouse_pos.y, mouse_pos.x)
	var mouse_pressed = activated and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if (value > 0) and mouse_pressed:
		if $AnimatedSprite2D.animation == 'paused':
			$AnimatedSprite2D.play('playing')
		float_value -= 0.5 * dt
		if float_value < 0:
			float_value = 0
	else:
		$AnimatedSprite2D.play('paused')

func get_boost_force(power):
	if value == 0:
		return Vector2.ZERO
	var ang = $AnimatedSprite2D.rotation
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return -Vector2(cos(ang), sin(ang)) * power
	return Vector2.ZERO
	
func reset_fuel():
	float_value = 1.0
