extends TileMap

var fuel_maker = preload("res://fuel.tscn")

func _ready():
	var lines = FileAccess.open('res://levels.txt', FileAccess.READ).get_as_text().split('\n')
	for i in lines:
		if len(i) == 0:
			continue
		if i[0] == 'p':
			var plat = get_platform(i.substr(2))
			add_child(plat)
		elif i[0] == 'f':
			var fuel = fuel_maker.instantiate()
			fuel.position = get_vec(i.substr(2))
			add_child(fuel)
			
func _process(dt):
	var pos = $Area2D.position
	for i in get_children():
		if i.has_method("fuel") and i.usable:
			if i.proximity(pos) < 75:
				i.use()
				$Area2D/ProgressBar.reset_fuel()
	
func get_vec(str):
	var first = true
	var n1 = ''
	var n2 = ''
	for i in str:
		if first:
			if i == ',':
				first = false
			elif i in '0123456789.':
				n1 += i
		else:
			if i in '0123456789.':
				n2 += i
	return Vector2(float(n1), float(n2))
		
func get_platform(str):
	var curnum = ''
	var open = false
	var firstnum = false
	var curvec
	var vecs = PackedVector2Array()
	for i in str:
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
			if curprot.length() > 0:
				i.ticks += 1
				tot += curprot
	return tot
	
	
