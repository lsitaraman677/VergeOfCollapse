extends Node2D

func _ready():
	#var mat = [
		#PackedFloat32Array([1, 1, -1]),
		#PackedFloat32Array([2, -1, 1]),
		#PackedFloat32Array([-1, 2, 2]),
	#]
	#var vals = PackedFloat32Array([-2, 5, 1])
	var plat = Platform.new()
	add_child(plat)
	#print(plat.solve_system(mat, vals))
	position = Vector2(300, 300)
	var p = []
	var curp = Vector2.ZERO
	p.append(curp)
	for i in range(4):
		var mag = 100 + randf() * 100
		var ang = randf() * 2 * PI
		var new = curp + Vector2(cos(ang), sin(ang)) * mag
		var rect = get_viewport().get_visible_rect()
		while not rect.has_point(to_global(new)):
			mag = 100 + randf() * 100
			ang = randf() * 2 * PI
			new = curp + Vector2(cos(ang), sin(ang)) * mag
		curp = new
		p.append(curp)
	#plat.initialize([	Vector2(0, 0),
						#Vector2(20, 20),
						#Vector2(160, 40),
						#Vector2(380, 20),
						#Vector2(400, 0)])
	plat.initialize(p)
	
func _process(dt: float):
	queue_redraw()
	
func _draw():
	var p = get_children()[0].min_dist(get_local_mouse_position(), 15)
	draw_circle(p, 5, Color(1, 1, 1))
	
func within_camera(rect):
	return true
