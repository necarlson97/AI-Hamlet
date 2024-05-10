extends Node3D
class_name Building

var items_needed = {
	Wood: 1,
}
# Number of 'people-days' that it takes to construct
# e.g.: 1 person 10 days, 10 people 1 days
var labor_needed = 10.0

# TODO would it be easier, instead of children having to keep track of this,
# to have a seperate 'Blueprint' which just looks like the building,
# has no functionality, but can get replaced?
var completed = false

var blueprint_prefab = preload("res://scenes/buildings/blueprint.tscn")
func _ready():
	# All buildings are visitalbe
	$"/root/PathfinderNode".add_node(self)
	create_blueprint()
	
func create_blueprint():
	# Create a 'blueprint' child to show the build progress
	var new_bp = blueprint_prefab.instantiate()
	add_child(new_bp)
	$MeshInstance3D.visible = false

func get_build_task():
	# If not yet built, get a task to continue building it
	# TODO
	pass

func perform_build_step(person: Person, item: CraftItem):
	if $Blueprint:
		# If we are done building
		if $Blueprint.perform_build_step(person, item):
			finish_build()
			

func finish_build():
	# If we completed construction, or called manually
	# for, say, starting building
	$Blueprint.queue_free()
	$MeshInstance3D.visible = true
