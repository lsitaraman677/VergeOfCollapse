extends Node2D

class_name Platform

var poly_x
var poly_y

func _ready():
	pass
	
func _process(dt: float):
	queue_redraw()

func initialize(points):
	var n = len(points)
	var minx = points[0].x
	var maxx = points[0].x
	var miny = points[0].y
	var maxy = points[0].y
	for i in range(n - 1):
		var curpoint = points[i + 1]
		if curpoint.x > maxx:
			maxx = curpoint.x
		if curpoint.x < minx:
			minx = curpoint.x
		if curpoint.y > maxy:
			maxy = curpoint.y
		if curpoint.y < miny:
			miny = curpoint.y
	var mat = []
	var vals_list_x = []
	var vals_list_y = []
	for i in range(n):
		var point = points[i]
		var t = float(i) / (n - 1)
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
	
	
	
