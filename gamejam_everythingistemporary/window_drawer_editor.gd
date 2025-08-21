extends Node2D

func _process(dt):
	queue_redraw()
	
func _draw():
	var rect = get_parent().window
	draw_rect(rect, Color(1, 1, 1), false, 4)
