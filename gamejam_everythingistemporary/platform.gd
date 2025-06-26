extends Node2D

class_name Platform

var poly_x
var poly_y
var bbox

func _ready():
	pass
	
func _process(dt: float):
	queue_redraw()

func initialize(points):
	var n = len(points)
	var total_length = 0.0
	for i in range(n - 1):
		var curpoint = points[i + 1]
		total_length += points[i].distance_to(curpoint)
	var mat = []
	var vals_list_x = []
	var vals_list_y = []
	var cur_length = 0.0
	for i in range(n):
		var point : Vector2 = points[i]
		if i > 0:
			cur_length += points[i - 1].distance_to(point)
		var t = cur_length / total_length
		var t_arr = PackedFloat32Array()
		t_arr.resize(n)
		for j in range(n):
			t_arr[j] = t ** j
		mat.append(t_arr)
		vals_list_x.append(point.x)
		vals_list_y.append(point.y)
	var vals_x = PackedFloat32Array(vals_list_x)
	var vals_y = PackedFloat32Array(vals_list_y)
	poly_x = solve_system(mat, vals_x)
	poly_y = solve_system(mat, vals_y)
	var t_int = 0
	var minx = points[0].x
	var maxx = points[0].x
	var miny = points[0].y
	var maxy = points[0].y
	while t_int <= 100:
		var t = t_int * 0.01
		var x = eval_poly(poly_x, t)
		var y = eval_poly(poly_y, t)
		if x > maxx:
			maxx = x
		if x < minx:
			minx = x
		if y > maxy:
			maxy = y
		if y < miny:
			miny = y
		t_int += 1
	bbox = Rect2(minx, miny, maxx - minx, maxy - miny)
		

func solve_system(mat_in, vals):
	var n = len(mat_in)
	var mat = []
	for i in range(n):
		var row = PackedFloat32Array()
		row.resize(n)
		for j in range(n):
			row[j] = mat_in[i][j]
		mat.append(row)
	for i in range(n - 1):
		var mat_idx = n - 1 - i
		var cur_tool = mat[mat_idx]
		var toolval = vals[mat_idx]
		var cur_tool_val = cur_tool[i]
		for j in range(mat_idx):
			var row = mat[j]
			var factor = -row[i] / cur_tool_val
			lincomb(cur_tool, factor, row)
			vals[j] += factor * toolval
	var res = PackedFloat32Array()
	res.resize(n)
	res[n - 1] = vals[0] / mat[0][n - 1]
	for i in range(1, n):
		var b = 0
		for j in range(n-1, n-1-i, -1):
			b += mat[i][j] * res[j]
		res[n - 1 - i] = solve_1var(mat[i][n - 1 - i], b, vals[i])
	return res
		
# Assigns target to target + factor * tool
func lincomb(tool, factor, target):
	for i in range(len(target)):
		target[i] += factor * tool[i]
		
# Solves ax + b = c for x		
func solve_1var(a, b, c):
	return (c - b) / a
	
func eval_poly(poly, val):
	var res = 0
	for i in range(len(poly)):
		res += poly[i] * val**i
	return res
	
func _draw():
	var t = 0.01
	var p1 = Vector2(eval_poly(poly_x, 0.0), eval_poly(poly_y, 0.0))
	while t < 1:
		var p2 = Vector2(eval_poly(poly_x, t), eval_poly(poly_y, t))
		draw_line(p1, p2, Color(1, 1, 1), 3)
		p1 = p2
		t += 0.01
	var p2 = Vector2(eval_poly(poly_x, 1.0), eval_poly(poly_y, 1.0))
	draw_line(p1, p2, Color(1, 1, 1), 3)
	draw_rect(bbox, Color(0, 0, 0), false, 3)
	
func dxdt(val=null):
	if val == null:
		var res = PackedFloat32Array()
		res.resize(len(poly_x) - 1)
		for i in range(len(res)):
			res[i] = poly_x[i+1] * (i+1)
		return res
	else:
		return eval_poly(dxdt(), val)

func dydt(val=null):
	if val == null:
		var res = PackedFloat32Array()
		res.resize(len(poly_y) - 1)
		for i in range(len(res)):
			res[i] = poly_y[i+1] * (i+1)
		return res
	else:
		return eval_poly(dydt(), val)
	
func dydx(val):
	return dydt(val) / dxdt(val)
		
func min_dist(point, finetune=0):
	var t = 0
	var best_t = 1.0
	var curp = Vector2(eval_poly(poly_x, 1.0), eval_poly(poly_y, 1.0))
	var mindist = curp.distance_to(point)
	while t <= 1.0:
		curp = Vector2(eval_poly(poly_x, t), eval_poly(poly_y, t))
		var dist = curp.distance_to(point)
		if dist < mindist:
			mindist = dist
			best_t = t
		t += 0.025
		# (x(t) - xi)^2 + (y(t) - yi^2)
		# 2(x(t) - xi)*x'(t) + 2(y(t) - yi)*y'(t)
	t = best_t
	var dxdt = dxdt()
	var dydt = dydt()
	var xt
	var yt
	for i in range(finetune):
		xt = eval_poly(poly_x, t)
		yt = eval_poly(poly_y, t)
		var dxdt_val = eval_poly(dxdt, t)
		var dydt_val = eval_poly(dydt, t)
		var deriv = 2 * (xt - point.x) * dxdt_val + 2 * (yt - point.y) * dydt_val
		var dl = deriv * 1e-4
		var dt = dl / ((dxdt_val**2 + dydt_val**2)**0.5)
		t -= dt
		#t -= deriv * 1e-7
		if t < 0:
			t = 0
		if t > 1:
			t = 1
	xt = eval_poly(poly_x, t)
	yt = eval_poly(poly_y, t)
	return Vector2(xt, yt)
		
		
	
	
	
	
