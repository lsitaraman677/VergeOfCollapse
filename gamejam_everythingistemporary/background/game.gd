extends TileMap

var window = Rect2(0, 0, 5000, 3000)
var finish
var go = false

func _ready():
	load_level("res://levels/level2.txt")
			
func _process(dt):
	if not go:
		if Input.is_action_pressed("ui_accept"):
			go = true
			set_play(true)
			$Area2D/ProgressBar.activated = true
			
	
func load_level(fname):
	var to_delete = []
	for child in get_children():
		if (child is Platform) or (child is Collectable):
			to_delete.append(child)
	for delete in to_delete:
		delete.queue_free()
	var lines = FileAccess.open(fname, FileAccess.READ).get_as_text().split('\n')
	var keys = 0
	var start = Collectable.new()
	var finish_vec
	for i in lines:
		if len(i) == 0:
			continue
		if i[0] == 'p':
			var plat = get_platform(i.substr(2))
			add_child(plat)
		elif i[0] == 'f':
			var fuel = Collectable.new()
			var sprite = $fuel.duplicate()
			sprite.show()
			fuel.initialize(get_vec(i.substr(2)), sprite)
			add_child(fuel)
		elif i[0] == 'k':
			keys += 1
			var key = Collectable.new()
			var sprite = $key.duplicate()
			sprite.show()
			key.initialize(get_vec(i.substr(2)), sprite)
			add_child(key)
		elif i[0] == 's':
			var sprite = $start.duplicate()
			sprite.show()
			start.initialize(get_vec(i.substr(2)), sprite)
		elif i[0] == 'e':
			finish_vec = get_vec(i.substr(2))
		elif i[0] == 'w':
			window = get_rect(i.substr(2))
	finish = Collectable.new()
	var sprite = $finish.duplicate()
	sprite.show()
	sprite.initialize(keys)
	finish.initialize(finish_vec, sprite)
	add_child(start)
	add_child(finish)
	$Area2D.position = start.initial_pos - Vector2(0, 50)
	go = false
	set_play(false)
	$Area2D/ProgressBar.activated = false
	$Area2D/ProgressBar.set_process(true)
	
	
func get_rect(s):
	var cur = ''
	var res = []
	for i in s:
		if i in '0123546789.':
			cur += i
		elif i == ',':
			res.append(float(cur))
			cur = ''
	res.append(float(cur))
	return Rect2(res[0], res[1], res[2], res[3])

func get_vec(s):
	var first = true
	var n1 = ''
	var n2 = ''
	for i in s:
		if first:
			if i == ',':
				first = false
			elif i in '0123456789.':
				n1 += i
		else:
			if i in '0123456789.':
				n2 += i
	return Vector2(float(n1), float(n2))

func get_platform(s):
	var curnum = ''
	var open = false
	var firstnum = false
	var curvec
	var vecs = PackedVector2Array()
	for i in s:
		if open:
			if firstnum:
				if i == ',':
					firstnum = false
					curvec.x = float(curnum)
					curnum = ''
				else:
					curnum += i
			else:
				if i == ')':
					open = false
					curvec.y = float(curnum)
					vecs.append(curvec)
					curnum = ''
				else:
					curnum += i
		else:
			if i == '(':
				open = true
				firstnum = true
				curvec = Vector2.ZERO
	if len(vecs) <= 1:
		return null
	var plat = Platform.new()
	plat.initialize(vecs)
	return plat
	
func within_camera(rect):
	var center = $Area2D.position
	var w = get_viewport_rect().size.x * $Area2D/Camera2D.scale.x
	var h = get_viewport_rect().size.y * $Area2D/Camera2D.scale.y
	return rect.intersects(Rect2(center.x - w * 0.5, center.y - h * 0.5, w, h))
	
func get_plat_prot():
	var tot = Vector2.ZERO
	for i in get_children():
		if i is Platform:
			var curprot = i.circle_protrusion_vec($Area2D.position, 50)
			if curprot.length() > 0.1:
				i.ticks += 1
				tot += curprot
		elif (i is Collectable) and (i.get_type() == 'finish'):
			tot += i.get_children()[0].get_prot($Area2D.position, 50)
	return tot

func touched(area):
	if not area.is_visible_in_tree():
		return
	var p = area.get_parent()
	if p.get_parent().usable:
		p.get_parent().use()
		if p.name == 'fuel':
			$Area2D/ProgressBar.reset_fuel()
		elif p.name == 'key':
			finish.add_key()
		elif p.name == 'finish':
			print('here')
			
func set_play(p):
	var children = [get_children()]
	var next_children = []
	while true:
		for child_list in children:
			for child in child_list:
				child.set_process(p)
				next_children.append(child.get_children())
		if len(next_children) == 0:
			return
		children = next_children
		next_children = []
	
	
