extends Camera2D

var v = Vector2.ZERO
const slowfact = 0.9
const power = 8000

func _process(dt):
	if Input.is_action_pressed("ui_left"):
		v.x -= power * dt
	if Input.is_action_pressed("ui_right"):
		v.x += power * dt
	if Input.is_action_pressed("ui_up"):
		v.y -= power * dt
	if Input.is_action_pressed("ui_down"):
		v.y += power * dt
	v *= slowfact
	position += v * dt
	
