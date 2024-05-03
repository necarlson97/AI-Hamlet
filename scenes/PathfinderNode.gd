extends Node3D

class_name  PathfinderNode
var neighbors = []

func _init(pos: Node3D):
	global_position = pos.global_position

func distance_to(target: PathfinderNode) -> float:
	return global_position.distance_to(target.global_position)

func _to_string():
	return 
