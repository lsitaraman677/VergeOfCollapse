extends Sprite2D

const pos = Vector2(2, -4)
const time = 1.0
const yshift = 30
var anim = -1

func _process(dt):
	if anim > 0:
		modulate.a = anim
		position = pos + Vector2(0, yshift * (anim * anim - 1))
		anim -= dt / time
	elif anim != -1:
		anim = -1
		hide()
