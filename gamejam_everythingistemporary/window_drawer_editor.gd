extends Node2D

func _process(dt):
	queue_redraw()
	
func _draw():
	var rect = get_parent().window
	draw_rect(rect, Color(1, 1, 1), false, 4)
	if(get_parent().tlp != null):
		draw_circle(get_parent().tlp, 10, Color(1, 0, 0), false)
	if(get_parent().trp != null):
		draw_circle(get_parent().trp, 10, Color(1, 0, 0), false)
	if(get_parent().blp != null):
		draw_circle(get_parent().blp, 10, Color(1, 0, 0), false)
	if(get_parent().brp != null):
		draw_circle(get_parent().brp, 10, Color(1, 0, 0), false)
