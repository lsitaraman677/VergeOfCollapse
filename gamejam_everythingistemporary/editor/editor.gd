extends TileMap

var window = Rect2(0, 0, 1000, 1000)
var old_window = Rect2(0, 0, 1000, 1000)
var tlp = null
var trp = null
var blp = null
var brp = null

var base_fuel
var base_key
var base_start
var base_finish
var active = ''
var modmode = ''
var prev_pos_mouse
var prev_pos_obj
var holding = null
var plat_to_mod = null
var idx = -1
var ptcol
var pt = null
const dotshift = 30
const dotshiftside = 15
var objects = []

var cur_level = ''
var action = ''

func _ready():
	var scene = preload('res://background/game.tscn').instantiate()
	add_child(scene)
	base_fuel = scene.get_node("fuel").duplicate()
	base_key = scene.get_node("key").duplicate()
	base_start = scene.get_node("start").duplicate()
	base_finish = scene.get_node("finish").duplicate()
	scene.queue_free()
	add_pressed()
	visibility_changed.connect(toggle_ticking)

func _process(dt):
	if $Camera2D/accept.visible:
		return
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
	if holding != null:
		if idx == -1:
			holding.position = prev_pos_obj + get_global_mouse_position() - prev_pos_mouse
		else:
			holding.pts[idx] = prev_pos_obj + get_global_mouse_position() - prev_pos_mouse
			holding.initialize(holding.pts)
			pt = holding.pts[idx]

func platform_pressed():
	active = 'p'
	var p = $Camera2D/platform
	$Camera2D.active_dot_top = p.position + p.size * 0.5 - Vector2(0, dotshift)
	
func fuel_pressed():
	active = 'f'
	var f = $Camera2D/fuel
	$Camera2D.active_dot_top = f.position + f.size * 0.5 - Vector2(0, dotshift)
	
func key_pressed():
	active = 'k'
	var k = $Camera2D/key
	$Camera2D.active_dot_top = k.position + k.size * 0.5 - Vector2(0, dotshift)
	
func start_pressed():
	active = 's'
	var s = $Camera2D/start
	$Camera2D.active_dot_top = s.position + s.size * 0.5 - Vector2(0, dotshift)
	
func finish_pressed():
	active = 'e'
	var e = $Camera2D/finish
	$Camera2D.active_dot_top = e.position + e.size * 0.5 - Vector2(0, dotshift)
	
func add_pressed():
	var f = $Camera2D/add
	$Camera2D.active_dot_side = f.position + Vector2(-dotshiftside, f.size.y * 0.5)
	modmode = 'a'
	
func modify_pressed():
	var f = $Camera2D/modify
	$Camera2D.active_dot_side = f.position + Vector2(-dotshiftside, f.size.y * 0.5)
	modmode = 'm'
	
func remove_pressed():
	var f = $Camera2D/remove
	$Camera2D.active_dot_side = f.position + Vector2(-dotshiftside, f.size.y * 0.5)
	modmode = 'r'
	
func _input(input: InputEvent):
	if $Camera2D/accept.visible or $Camera2D/save/accept_level.visible:
		return
	var pos = get_global_mouse_position()
	if not within_buttons(pos):
		return
	if (input is InputEventMouseButton) and input.button_index == 1 and (not input.pressed):
		if (holding is Platform) and (idx == -1):
			for i in range(len(holding.pts)):
				holding.pts[i] += holding.position
			holding.initialize(holding.pts)
			holding.position = Vector2.ZERO
		holding = null
		idx = -1
	if modmode == 'a':
		pt = null
		if (input is InputEventMouseButton) and input.pressed and input.button_index == 1:
			var obj = null
			if active == 's':
				obj = base_start.duplicate()
			elif active == 'e':
				obj = base_finish.duplicate()
			elif active == 'k':
				obj = base_key.duplicate()
			elif active == 'f':
				obj = base_fuel.duplicate()
			if obj != null:
				obj.position = get_global_mouse_position()
				obj.show()
				objects.append(obj)
				add_child(obj)
			elif active == 'p':
				obj = Platform.new()
				obj.initialize([pos, pos + Vector2(100, 0)])
				objects.append(obj)
				add_child(obj)
	elif modmode == 'm':
		if holding != null:
			return
		pt = null
		$Area2D.position = pos
		var overlapped = null
		for obj in objects:
			if obj is Platform:
				var testRect = Rect2(obj.bbox.position, obj.bbox.size)
				testRect.position -= Vector2(20, 20)
				testRect.size += Vector2(40, 40)
				if (overlapped == null) and testRect.has_point(pos):
					if pos.distance_to(obj.min_dist(pos)) < 30:
						overlapped = obj
						obj.modulate = Color(1, 1, 1, 0.6)
					else:
						obj.modulate = Color(1, 1, 1, 1)
				else:
					obj.modulate = Color(1, 1, 1, 1)
			else:
				if (overlapped == null) and $Area2D.overlaps_area(obj.get_child(0)):
					overlapped = obj
					obj.modulate = Color(1, 1, 1, 0.6)
				else:
					obj.modulate = Color(1, 1, 1, 1)
		if overlapped == null:
			return
		idx = -1
		if overlapped is Platform:
			for i in range(len(overlapped.pts)):
				if pos.distance_to(overlapped.pts[i]) < 15:
					idx = i
					pt = overlapped.pts[i]
					ptcol = Color.ORANGE
					break
			if idx == -1:
				var return_val = overlapped.min_dist_full(pos, 15)
				ptcol = Color.GREEN
				if pos.distance_to(return_val[0]) < 4:
					pt = return_val[0]
					if (input is InputEventMouseButton) and input.button_index == 1 and input.pressed:
						idx = overlapped.add_point_at(return_val[1])
		if (input is InputEventMouseButton) and input.pressed:
			if input.button_index == 1:
				prev_pos_mouse = pos
				holding = overlapped
				if idx == -1:
					prev_pos_obj = overlapped.position
				else:
					prev_pos_obj = overlapped.pts[idx]
			elif input.button_index == 2:
				if overlapped is Platform:
					plat_to_mod = overlapped
					$Camera2D/accept/plat_time.text = str(overlapped.max_time)
					$Camera2D/accept.show()
	else:
		$Area2D.position = pos
		var overlapped = -1
		for idx in range(len(objects)):
			var obj = objects[idx]
			if obj is Platform:
				var testRect = Rect2(obj.bbox.position, obj.bbox.size)
				testRect.position -= Vector2(20, 20)
				testRect.size += Vector2(40, 40)
				if (overlapped == -1) and testRect.has_point(pos):
					if pos.distance_to(obj.min_dist(pos)) < 20:
						overlapped = idx
						obj.modulate = Color(1.5, 0.5, 0.5, 1)
					else:
						obj.modulate = Color(1, 1, 1, 1)
				else:
					obj.modulate = Color(1, 1, 1, 1)
			else:
				if (overlapped == -1) and $Area2D.overlaps_area(obj.get_child(0)):
					overlapped = idx
					obj.modulate = Color(1.5, 0.5, 0.5, 1)
				else:
					obj.modulate = Color(1, 1, 1, 1)
		if (input is InputEventMouseButton) and input.button_index == 1 and input.pressed:
			if overlapped != -1:
				objects[overlapped].queue_free()
				objects.remove_at(overlapped)

func within_buttons(pos):
	var left_bound = $Camera2D/add
	var top_bound = $Camera2D/key
	var bot_bound = $Camera2D/save
	if pos.x < left_bound.global_position.x + left_bound.size.x:
		return false
	if pos.y < top_bound.global_position.y + top_bound.size.y:
		return false
	if pos.y > bot_bound.global_position.y:
		return false
	return true

func save_objects(fname):
	var f = FileAccess.open(fname, FileAccess.WRITE)
	var s = ''
	var start = false
	var end = false
	for i in objects:
		var cur = ''
		if i is Platform:
			cur += 'p: '
			for p in i.pts:
				cur += str(p) + ', '
			cur += str(i.max_time) 
		else:
			if i.has_method('fuel'):
				cur = 'f: '
			elif i.has_method('key'):
				cur = 'k: '
			elif i.has_method('start'):
				start = true
				cur = 's: '
			else:
				end = true
				cur = 'e: '
			cur += str(i.position)
		s += cur + '\n'
	var wp = window.position
	var ws = window.size
	s += 'w: ' + '(' + str(wp.x) + ', ' + str(wp.y) + ', ' + str(ws.x) + ', ' + str(ws.y)+ ')\n'
	if start and end:
		f.store_string(s)
		print(s)
		action = 'level saved'
	f.close()	
			
func within_camera(rect):
	var center = $Camera2D.position
	var w = get_viewport_rect().size.x * $Camera2D.scale.x
	var h = get_viewport_rect().size.y * $Camera2D.scale.y
	return rect.intersects(Rect2(center.x - w * 0.5, center.y - h * 0.5, w, h))
	
func accept_pressed():
	var num = $Camera2D/accept/plat_time.text
	if num.is_valid_float():
		plat_to_mod.max_time = float(num)
	$Camera2D/accept.hide()

func toggle_ticking():
	set_process(visible)
	action = ''

func load_level(fname):
	print('starting loading process')
	cur_level = fname
	remove_all()
	var lines = FileAccess.open(fname, FileAccess.READ).get_as_text().split('\n')
	for i in lines:
		if len(i) == 0:
			continue
		if i[0] == 'p':
			var plat = MainGame.get_platform(i.substr(2))
			add_child(plat)
			objects.append(plat)
		elif i[0] == 'f':
			var fuel = base_fuel.duplicate()
			fuel.position = MainGame.get_vec(i.substr(2))
			fuel.show()
			add_child(fuel)
			objects.append(fuel)
		elif i[0] == 'k':
			var key = base_key.duplicate()
			key.position = MainGame.get_vec(i.substr(2))
			key.show()
			add_child(key)
			objects.append(key)
		elif i[0] == 's':
			var start = base_start.duplicate()
			start.position = MainGame.get_vec(i.substr(2))
			start.show()
			add_child(start)
			objects.append(start)
		elif i[0] == 'e':
			var end = base_finish.duplicate()
			end.position = MainGame.get_vec(i.substr(2))
			end.show()
			add_child(end)
			objects.append(end)
		elif i[0] == 'w':
			window = MainGame.get_rect(i.substr(2))
			old_window = Rect2(window.position * 1.0, window.size * 1.0)
	print('loaded level')
	$Camera2D.position = window.position

func remove_all():
	objects = []
	for child in get_children():
		if child == $Node2D or child == $Camera2D or child == $Area2D:
			continue
		child.queue_free()

func ask_load_level():
	action = 'load level'
	
func quit():
	action = 'quit'
