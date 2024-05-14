extends Node3D
class_name Arbor
# Unfortunatly, cannot name 'Tree' as that is a standard gd class
# TODO abstract to a 'Harvestable'?

var wood_prefab = preload("res://scenes/crafting/wood.tscn")

# TODO growing, creating offspring, etc
func harvest() -> CraftItem:
	var item = wood_prefab.instantiate()
	# TODO falling over, whatever
	# TODO I think maybe best implemented as creating a new
	# 'Fallen tree' scene that has a cutting down animation on start
	queue_free()
	return item
