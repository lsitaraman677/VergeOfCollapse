extends Area2D

var velocity = Vector2.ZERO
var g = 2000
var cur_delta

var boostcol
const boostSize = 100
const power = 3000
const airRes = 0.001
const forceFact = 50

func get_bounds():
	return get_parent().window

func _ready():
	boostcol = []
	var col = Color(randf(), randf(), randf())
	for i in range(3):
		boostcol.append(col)
	
func _process(dt):
	cur_delta = dt
	if not get_parent().go:
		return
	updatePos(dt)
	
func updatePos(dt): 
	var force = $ProgressBar.get_boost_force(power)
	velocity += force * dt
	velocity.y += g * dt
	velocity -= velocity.normalized() * (velocity.length()**2 * airRes) * dt
	var oldPos = position
	position += velocity * dt
	var moveDir = get_parent().get_plat_prot()
	if moveDir.length() > 0.1:
		position += moveDir
		velocity = (position - oldPos) / dt
	var window = get_bounds()
	if position.x < window.position[0] + 50:
		position.x = window.position[0] + 50
		velocity.x = 0
	elif position.x > window.position[0] + window.size[0] - 50:
		position.x = window.position[0] + window.size[0] - 50
		velocity.x = 0
	if position.y < window.position[1] + 50:
		position.y = window.position[1] + 50
		velocity.y = 0
	elif position.y > window.position[1] + window.size[1] - 50:
		position.y = window.position[1] + window.size[1] - 50
		velocity.y = 0
		
