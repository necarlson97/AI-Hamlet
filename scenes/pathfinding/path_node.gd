extends Node3D
class_name  PathNode

var neighbors = []

func distance_to(target: PathNode) -> float:
	return global_position.distance_to(target.global_position)

func _to_string() -> String:
	return name as String
