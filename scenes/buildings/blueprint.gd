extends Node3D

var items_added = {}
var labor_done = 0.0

var building_name: String
var building: Building

func _ready():
	assert(building_name, "Building name was not set for blueprint %s"%self)
	# Create building, but do not yet add it to tree
	var building_path = "res://scenes/buildings/%s.tscn"%building_name
	var building_prefab  = load(building_path)
	assert(building_prefab, "Unable to load %s (%s)"%[building_name, building_path])
	building = building_prefab.instantiate()
	
	# Set our blueprint to match the building will look like
	var building_mesh_inst = building.get_node("MeshInstance3D")
	var parent_color = building_mesh_inst.get_active_material(0).albedo_color
	$MeshInstance3D.get_active_material(0).set_shader_parameter("base_color", parent_color)
	$MeshInstance3D.mesh = building_mesh_inst.mesh
	update_buld_progress()
	assign_build_tasks()
	
	# What items we actually need
	for item_name in building.items_needed:
		items_added[item_name] = 0

func assign_build_tasks():
	# Post to the bulliten the tasks that are needed to complete the building
	var bulletin = $"/root/UtilsNode".get_matching_node(Bulletin, true)
	if not bulletin:
		print("No bulletin found, so not assigning build tasks")
		return
	
	# Tasks to do labor
	for i in Vector3(0, building.labor_needed, Task.ConstructionLabor.work_day):
		bulletin.add_task(Task.ConstructionLabor.new(2, self))
		
	# Taks to get items
	for item_name in building.items_needed:
		var item_count = building.items_needed[item_name]
		for i in range(item_count):
			bulletin.add_task(Task.BringItemTo.new(2, self, item_name))

func add_item(person: Person, item: CraftItem):
	# TODO put the item into the building
	# TODO actually check if it is what we need
	assert(item.name in items_added, "%s does not need %s (%s)"%[self, item, building])
	items_added[item.name] += 1
	item.queue_free()
	update_buld_progress()
	
	# TODO for now, always returns true, as it throws an error if item was wrong
	return true
	
func perform_labor(days):
	labor_done += days
	update_buld_progress()

func items_needed_count():
	return Utils.sum(building.items_needed.values())
func items_added_count():
	return Utils.sum(items_added.values())

func get_progress() -> float:
	# Get progress from 0-1
	var item_progress = float(items_added_count()) / items_needed_count()
	var labor_progress = labor_done / building.labor_needed
	
	# TODO debug Label3D?
	print("item_progress: %s, labor_progress: %s"%[item_progress, labor_progress])
	
	return clampf((item_progress + labor_progress) * 0.5, 0, 1)

func update_buld_progress():
	# Start, visually, at 0.1 so we can see the bottom of the thing
	var progress = clampf(get_progress(), 0.1, 1)
	$MeshInstance3D.get_active_material(0).set_shader_parameter("ratio", progress)
	# If we are finished, create building 
	if get_progress() >= 1.0:
		finish_build()

func finish_build():
	# Remove blueprint, officially add building to tree
	get_parent().add_child(building)
	building.global_position = global_position
	queue_free()
