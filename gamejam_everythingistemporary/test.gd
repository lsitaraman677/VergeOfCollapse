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
	plat.initialize([	Vector2(0, 0),
						Vector2(20, 50),
						Vector2(400, -50)])
	
func _process(dt: float):
	pass
