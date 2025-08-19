extends Area2D

var velocity = Vector2.ZERO
var g = 2000
var cur_delta

var boostcol
const boostSize = 100
const power = 3000
const slowFact = 0.985
const forceFact = 50

func _ready():
	boostcol = []
	var col = Color(randf(), randf(), randf())
	for i in range(3):
		boostcol.append(col)
	position = get_viewport().get_window().size * 0.5
	
func _process(dt):
	cur_delta = dt
	updatePos(dt)
	
func updatePos(dt):
	if Input.is_action_pressed("ui_accept"):
		return
	var force = $ProgressBar.get_boost_force(power)
	velocity += force * dt
	velocity.y += g * dt
	velocity *= slowFact
	var oldPos = position
	position += velocity * dt
	var moveDir = get_parent().get_plat_prot()
	if moveDir.length() > 0.1:
		position += moveDir
		velocity = (position - oldPos) / dt
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
		
	
