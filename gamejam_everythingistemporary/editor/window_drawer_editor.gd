extends Node2D

func _process(dt):
	queue_redraw()
	
func _draw():
	var rect = get_parent().window
	draw_rect(rect, Color(1, 1, 1), false, 4)
	var w = get_parent().window
	if(get_parent().tlp != null):
		draw_circle(w.position, 10, Color(1, 0, 0), false)
	if(get_parent().trp != null):
		draw_circle(w.position + Vector2(w.size.x, 0), 10, Color(1, 0, 0), false)
	if(get_parent().blp != null):
		draw_circle(w.position + Vector2(0, w.size.y), 10, Color(1, 0, 0), false)
	if(get_parent().brp != null):
		draw_circle(w.position + w.size, 10, Color(1, 0, 0), false)
