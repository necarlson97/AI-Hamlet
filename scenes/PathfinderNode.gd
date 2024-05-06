extends Node3D

class_name  PathfinderNode
var neighbors = []
	
const PathfinderNodePrefab = preload("res://scenes/pathfinder_node.tscn")
static func create(pos: Node3D) -> PathfinderNode:
	# Create a new pathfinder node
	# (must be actualy instantiated, as godot requires that for distance calc
	# - and it lets us debug easier
	var new = PathfinderNodePrefab.instantiate()
	new.name = ("Node %s" % pos.name.substr(0, 10))
	new.global_position = pos.global_position
	return new as PathfinderNode

func distance_to(target: PathfinderNode) -> float:
	return global_position.distance_to(target.global_position)

func _to_string() -> String:
	return name as String
