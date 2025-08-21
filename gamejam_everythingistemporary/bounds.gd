extends Node2D

func _process(dt):
	queue_redraw()
	
func _draw():
	draw_rect(get_parent().get_children()[1].window, Color.GRAY, false, 4)
