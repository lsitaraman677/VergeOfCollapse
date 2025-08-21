extends Node2D

var usable = true

func proximity(vector):
	return vector.distance_to($Sprite2D.global_position)

func use(override = false):
	if override or usable:
		$Sprite2D.anim = 1
		usable = false

func reset():
	$Sprite2D.anim = -1
	show()
	usable = true
		
func fuel():
	pass
