extends Node2D

class_name Collectable

var usable = true
const time = 1.0
const yshift = 30
var anim = -1
var initial_pos

func proximity(vector):
	return vector.distance_to(global_position)

func use(override=false):
	if override or usable:
		anim = 1
		usable = false

func reset():
	anim = -1
	show()
	usable = true

func _process(dt):
	if anim > 0:
		modulate.a = anim
		position = initial_pos + Vector2(0, yshift * (anim * anim - 1))
		anim -= dt / time
	elif anim != -1:
		hide()
		position = initial_pos
		
func get_type():
	var children = get_children()
	if len(children) == 0:
		return ""
	return children[0].name
	
func initialize(pos, sprite):
	initial_pos = pos
	position = pos
	add_child(sprite)
