extends Camera2D

var v = Vector2.ZERO
const slowfact = 0.9
const power = 8000

var active_dot_top = null
var active_dot_side = null


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
	queue_redraw()
	
func _draw():
	if active_dot_top != null:
		draw_circle(active_dot_top, 5, Color(1, 0, 0))
	draw_circle(active_dot_side, 5, Color(0, 0, 1))
	

	
