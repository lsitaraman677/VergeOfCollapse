extends TileMap

var window = Rect2(0, 0, 1000, 1000)
var old_window
var tlp = null
var trp = null
var blp = null
var brp = null

func _process(dt):
	var mpos = get_local_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tlp != null:
			window.position = mpos - tlp + old_window.position
		elif trp != null:
			window.position.y = mpos
