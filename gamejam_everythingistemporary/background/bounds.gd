extends Node2D

func _process(dt):
	var loc = get_parent().get_node("Area2D").global_position - Vector2(400, 200)
	$success.global_position = loc
	queue_redraw()
	
func _draw():
	var a2d = get_parent().get_node("Area2D")
	draw_rect(a2d.get_bounds(), Color.GRAY, false, 4)
	if $success.visible:
		var rect = Rect2(Vector2(-1000, -1000) + a2d.position, Vector2(2000, 2000))
		draw_rect(rect, Color(0, 0, 0, $success.modulate.a))
