extends Node2D

func _process(dt):
	queue_redraw()
	
func _draw():
	draw_circle(Vector2.ZERO, 50, Color(0, 0, 0))
