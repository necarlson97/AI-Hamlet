extends Node3D

var items_added = {}
var labor_done = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent_mat = get_parent().get_node("MeshInstance3D").get_active_material(0)
	var parent_color = parent_mat.albedo_color
	$MeshInstance3D.get_active_material(0).set_shader_parameter("base_color", parent_color)
	update_buld_progress()
	assign_build_tasks()

func assign_build_tasks():
	# Post to the bulliten the tasks that are needed to complete the building
	var bulletin = $"/root/UtilsNode".get_matching_node(Bulletin, true)
	if not bulletin:
		print("No bulletin found, so not assigning build tasks")
		return

	var par = get_parent()
	# Taks to get items
	for item_name in par.items_needed:
		var item_count = par.items_needed[item_name]
		for i in range(item_count):
			bulletin.add_task(Task.BringItemTo.new(2, par, item_name))
	# Tasks to do labor
	for i in range(par.labor_needed):
		bulletin.add_task(Task.ConstructionLabor.new(2, par))


func perform_build_step(person: Person, item: CraftItem):
	# TODO put the item into the building
	# TODO actually check if it is what we need
	if false: return false
	items_added[Wood] += 1
	item.queue_free()
	update_buld_progress()
	
	# Return true if we are done
	return get_progress() >= 1.0

func items_needed_count():
	return Utils.sum(get_parent().items_needed.values())
func items_added_count():
	return Utils.sum(items_added.values())

func get_progress() -> float:
	# Get progress from 0-1
	var item_progress = float(items_added_count()) / items_needed_count()
	var labor_progress = labor_done / get_parent().labor_needed
	
	return clampf((item_progress + labor_progress) * 0.5, 0, 1)

func update_buld_progress():
	# Start, visually, at 0.1 so we can see the bottom of the thing
	var progress = clampf(get_progress(), 0.1, 1)
	$MeshInstance3D.get_active_material(0).set_shader_parameter("ratio", progress)
	
