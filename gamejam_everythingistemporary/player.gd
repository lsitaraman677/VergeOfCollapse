extends Area2D

var velocity = Vector2.ZERO
var g = 2000
var boostAng = 0
var cur_delta

var boostcol
const boostSize = 100
const power = 3000
const slowFact = 0.975

func _ready():
	boostcol = []
	var rand = RandomNumberGenerator.new()
	var col = Color(rand.randf(), rand.randf(), rand.randf())
	for i in range(3):
		boostcol.append(col)
	position = get_viewport().get_window().size * 0.5
	
func _process(dt):
	cur_delta = dt
	var mouse_pos = get_local_mouse_position()
	boostAng = atan2(mouse_pos.y, mouse_pos.x)
	queue_redraw()
	updatePos(dt)

func _draw():
	
	var a1 = boostAng + (5 * PI / 6)
	var a2 = boostAng - (5 * PI / 6)
	var p1 = boostSize * Vector2(cos(a1), sin(a1))
	var p2 = boostSize * Vector2(cos(a2), sin(a2))
	draw_polygon([Vector2.ZERO, p1, p2], boostcol)
	
func updatePos(dt):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var force = power * Vector2(cos(boostAng), sin(boostAng))
		velocity += force * dt
		velocity.y += g * dt
		velocity *= slowFact
	else:
		velocity.y += g * dt
		velocity *= slowFact
		if velocity.length() < 10:
			velocity = Vector2.ZERO
	position += velocity * dt
	var window = get_parent().size
	if position.x < 0:
		position.x = 0
		velocity.x = 0
	elif position.x > window.x:
		position.x = window.x
		velocity.x = 0
	if position.y < 0:
		position.y = 0
		velocity.y = 0
	elif position.y > window.y:
		position.y = window.y
		velocity.y = 0
		
	
