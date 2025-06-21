extends Node

var poly_x
var poly_y

func _ready():
	pass
	
func _process(dt: float):
	pass

func initialize(points):
	pass

func get_poly(x, y):
	pass

# Assigns target to target + factor * tool
func lincomb(tool, factor, target):
	for i in range(len(target)):
		target[i] += factor * tool[i]
		
# Solves ax + b = c for x		
func solve_1var(a, b, c):
	return (c - b) / a
	
