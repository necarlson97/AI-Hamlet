extends Node3D
# Handles the placing of trees, boulders, etc

@onready var tree_prefabs = [
	preload("res://scenes/island/trees/palm.tscn"),
	preload("res://scenes/island/trees/cedar.tscn"),
	preload("res://scenes/island/trees/cedar.tscn"),
	preload("res://scenes/island/trees/pine.tscn"),
]
var tree_count = 1000 # TODO what is reasonable here?

# Called when the node enters the scene tree for the first time.
func _ready():
	# For now, can place tree anywhere on map
	var spread = get_parent().map_size
	# 1/4th of height is underwater
	var map_height = get_parent().height * 0.75
	while tree_count > 0:
		var v = $"/root/UtilsNode".rand_ground_vec(spread)
		var tree_index = (v.y / map_height) * tree_prefabs.size()
		var new_tree = tree_prefabs[tree_index].instantiate()
		add_child(new_tree)
		new_tree.global_position = v
		tree_count -= 1

