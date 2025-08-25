extends Camera2D

var v = Vector2.ZERO
const slowfact = 0.9
const power = 8000

var active = ''
var active_dot = null
const dotshift = 30

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
	if active_dot != null:
		draw_circle(active_dot, 5, Color(1, 0, 0))
	
func platform_pressed():
	active = 'p'
	active_dot = $platform.position + $platform.size * 0.5 - Vector2(0, dotshift)
	
func fuel_pressed():
	active = 'f'
	active_dot = $fuel.position + $fuel.size * 0.5 - Vector2(0, dotshift)
	
func start_pressed():
	active = 's'
	active_dot = $start.position + $start.size * 0.5 - Vector2(0, dotshift)
	
func finish_pressed():
	active = 'e'
	active_dot = $finish.position + $finish.size * 0.5 - Vector2(0, dotshift)
