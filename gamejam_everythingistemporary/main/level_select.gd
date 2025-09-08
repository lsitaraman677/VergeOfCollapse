extends Node2D

var clicked_file = ''

func _ready():
	update_children()
	visibility_changed.connect(func(): clicked_file = '')
	
func _process(dt):
	queue_redraw()
	
func _draw():
	draw_rect(Rect2(-1000, -1000, 4000, 4000), Color.DIM_GRAY)
	
func update_children():
	var x = 0
	var y = 0
	for child in get_children():
		if (child is Button) and not (child == $Exit):
			child.queue_free()
	var dir = DirAccess.open('res://levels/')
	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname:
		var b = Button.new()
		b.position = $builtin.position + Vector2(x, 100 + y)
		b.size = Vector2(100, 50)
		b.text = fname.substr(0, len(fname) - 4)
		var f = func(): clicked_file = 'res://levels/' + fname
		b.pressed.connect(f)
		add_child(b)
		x += 200
		if x > 1000:
			x = 0
			y += 100
		fname = dir.get_next()
	x = 0
	y = 0
	dir = DirAccess.open('user://')
	dir.list_dir_begin()
	fname = dir.get_next()
	while fname:
		if not fname.ends_with('txt'):
			fname = dir.get_next()
			continue
		var b = Button.new()
		b.position = $custom.position + Vector2(x, 100 + y)
		b.size = Vector2(100, 50)
		b.text = fname.substr(0, len(fname) - 4)
		var f = func(): clicked_file = 'user://' + fname
		b.pressed.connect(f)
		add_child(b)
		x += 200
		if x > 1000:
			x = 0
			y += 100
		fname = dir.get_next()
		
func exit():
	clicked_file = '__exit__'
