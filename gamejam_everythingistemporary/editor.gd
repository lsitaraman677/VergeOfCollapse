extends TileMap

var window = Rect2(0, 0, 1000, 1000)
var old_window = Rect2(0, 0, 1000, 1000)
var tlp = null
var trp = null
var blp = null
var brp = null

func _process(dt):
	var mpos = get_local_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tlp != null:
			var diff = mpos - tlp
			window.position = old_window.position + diff
			window.size = old_window.size - diff
		elif trp != null:
			var ydiff = mpos.y - trp.y
			window.position.y = old_window.position.y + ydiff
			window.size.y = old_window.size.y - ydiff
			window.size.x = mpos.x - trp.x + old_window.size.x
		elif blp != null:
			var xdiff = mpos.x - blp.x
			window.position.x = old_window.position.x + xdiff
			window.size.x = old_window.size.x - xdiff
			window.size.y = mpos.y - blp.y + old_window.size.y
		elif brp != null:
			window.size = mpos - brp + old_window.size
	else:
		var tl = window.position
		var tr = window.position + Vector2(window.size.x, 0)
		var bl = window.position + Vector2(0, window.size.y)
		var br = window.position + window.size
		if tl.distance_to(mpos) < 10:
			tlp = mpos
		else:
			tlp = null
		if tr.distance_to(mpos) < 10:
			trp = mpos
		else:
			trp = null
		if bl.distance_to(mpos) < 10:
			blp = mpos
		else:
			blp = null
		if br.distance_to(mpos) < 10:
			brp = mpos
		else:
			brp = null
		old_window = Rect2(window.position, window.size)
			
