extends Node3D
class_name  PathNode

var neighbors = []
	
const PathNodePrefab = preload("res://scenes/pathfinding/path_node.tscn")
static func create(pos: Node3D) -> PathNode:
	# Create a new pathfinder node
	# (must be actualy instantiated, as godot requires that for distance calc
	# - and it lets us debug easier
	var new = PathNodePrefab.instantiate()
	new.name = ("Node %s" % pos.name.substr(0, 10))
	new.global_position = pos.global_position
	return new as PathNode

func distance_to(target: PathNode) -> float:
	return global_position.distance_to(target.global_position)

func _to_string() -> String:
	return name as String
