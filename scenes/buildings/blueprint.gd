extends Node3D

var items_added = {}
var labor_done = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent_mat = get_parent().get_node("MeshInstance3D").get_active_material(0)
	var parent_color = parent_mat.albedo_color
	$MeshInstance3D.get_active_material(0).set_shader_parameter("base_color", parent_color)
	update_buld_progress()


func perform_build_step(person: Person, item: CraftItem):
	# TODO put the item into the building
	# TODO actually check if it is what we need
	if false: return false
	items_added[Wood] += 1
	item.queue_free()
	update_buld_progress()
	
	# Return true if we are done
	return get_progress() >= 1.0

func get_progress() -> float:
	# Get progress from 0-1
	var par = get_parent()
	var item_progress = Utils.sum(items_added.values()) / Utils.sum(par.items_needed.values())
	var labor_progress = labor_done / par.labor_needed
	
	return clampf((item_progress + labor_progress) * 0.5, 0, 1)

func update_buld_progress():
	# Start, visually, at 0.1 so we can see the bottom of the thing
	var progress = clampf(get_progress(), 0.1, 1)
	$MeshInstance3D.get_active_material(0).set_shader_parameter("ratio", progress)
	
