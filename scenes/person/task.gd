class_name Task

var priority : int
var target = null  # Can be used to specify a resource or location
var name = "AbstractTask" # Hate that I can't shadow vars - set in init of child

# highest priority is, for now, 5
# 5 = running from danger, pissing yourself, stealing food to survive, etc
# 4 = finishing the task you are doing (?)
# 3 = resolving somatic noramlly, like finding an outhouse, or getting a meal
# 2 = starting work on something new
# 1 = having fun, socalizing
# 0 = wandering, whatever
func _init(_priority=2, _target=null):
	priority = _priority
	target = _target

var _started = false
func start(person: Person):
	_started = true
	on_start(person)
	print("Starting %s"%self)
	
	# path to the vecor/node target, if we have one
	if target == null:
		return
	person.get_node("PathAgent").path_to_vec(get_target_vec())

func get_target_vec() -> Vector3:
	# Return the vector3 from the target
	if target == null: return Vector3()
	elif target is Vector3: return target
	elif target is Node3D: return target.global_position
	else:
		assert(false, "How do I get pos of %s %s (%s)?"%[name, target, typeof(target)])
		return Vector3(0, 0, 0)

func on_start(person: Person):
	# Subclass shadows if there is any logic needed on start
	pass

func perform(delta: float, person: Person) -> bool:
	# Try performing, returns true only if we are done
	# TODO we could call start ourself here, but for now, just report as error
	assert(_started, "%s (%s) was not started!"%[self, person])
	var completed = (
		has_arrived(person)
		and on_perform(person)
		and on_perform_delta(delta, person)
	)
	if completed:
		print("Completed %s"%self)
	return completed
	
func on_perform(person: Person) -> bool:
	# Subclass shadows to perform the task
	return true

func on_perform_delta(delta: float, person: Person) -> bool:
	# If subclass needs to the frame delta to tell if it is completed
	return true

func has_arrived(person: Person, threshold=3.0) -> bool:
	if target == null:
		return true
	return person.global_position.distance_to(get_target_vec()) < threshold
	
func _to_string():
	return "(%s) %s - %s" % [priority, name, get_target_vec().round()]

class GetItem extends Task:
	# Find the closest unclamed X and put it in person's inventory
	var item_name: String
	
	func _init(_priority=4, _item_name="Wood"):
		super(_priority)
		item_name = _item_name
		name = "GetItem"
		
	func on_start(person: Person):
		# TODO is this instant drop/pickup okay?
		print("Check if they are holding: %s %s=%s (%s)"%[person, person.get_held(), item_name, person.is_holding(item_name)])
		if person.is_holding(item_name): target = person.get_held()
		else: target = Utils.find_closest_to_person(person, item_name)
			
		if not target:
			print("Did not find %s, adding harvest task"%item_name)
			person.add_task(HarvestItem.new(priority, item_name))
		
	func on_perform(person: Person) -> bool:
		# TODO Pick it up!
		return person.pick_up(target)

class HarvestItem extends Task:
	# Find the closest raw item producer, and harvest for that item
	var item_name: String
	
	# TODO could have this pulled by some sort of property on
	# the raw producers or whatever, but just for now
	var item_producers = {
		"Wood": "arbor",
	}
	
	func _init(_priority=4, _item_name="Wood"):
		super(_priority)
		item_name = _item_name
		name = "HarvestItem"
		
	func on_start(person: Person):
		var producer = item_producers[item_name]
		target = Utils.find_closest_to_person(person, producer)
		assert(target, "Unable to find target item producer %s (%s)"%[producer, item_name])
		
	func on_perform(person: Person) -> bool:
		# TODO Pick it up!
		return person.pick_up(target.harvest())
		
class MakeBlueprint extends Task:
	# Go to a target vec, and start a building there
	var building_prefab
	
	func _init(_priority=2, _target=Vector3(0, 0, 0), _building_name="outhouse"):
		super(_priority, _target)
		var building_path = "res://scenes/buildings/%s.tscn"%_building_name
		building_prefab  = load(building_path)
		assert(building_prefab, "Unable to load %s (%s)"%[_building_name, building_path])
		name = "MakeBlueprint"
		
	func on_perform(person: Person) -> bool:
		var new_building = building_prefab.instantiate()
		person.get_tree().root.add_child(new_building)
		new_building.global_position = person.global_position
		
		# Adds tasks to finish the building
		return true

class BringItemTo extends Task:
	# Put x in the person's inventory, and bring it to construction site,
	# storage, etc
	var item_name: String
	
	func _init(_priority=2, _target=null, _item_name="Wood"):
		super(_priority, _target)
		item_name = _item_name
		name = "BringItemTo"
		assert(target, "Cannot have 'bring item' with null target ")
		
	func on_perform(person: Person) -> bool:
		# If you don't have the item, get one
		# TODO technically only called when you arrive at task,
		# maybe we should have a 'on_check' or something
		# that always runs, so we don't have to wait until we get there 
		# to figure out we gotta leave again
		if need_to_get(person): return false
			
		# TODO not exactly sure how to handle this. For now:
		if target.has_method("store_item"):
			return target.store_item(person.get_held())
		if target.has_method("add_item"):
			return target.add_item(person, person.get_held())

		assert(false, "How do I handle bring item to %s?"%target)
		return false
		
	func need_to_get(person: Person) -> bool:
		if person.is_holding(item_name): return false
		person.add_task(GetItem.new(priority, item_name))
		return true

class HarvestItemTo extends BringItemTo:
	# Like 'BringItemTo' - but only for harvesting. E.g.:
	# when filling storage, you don't want to pull from other storage
	func need_to_get(person: Person) -> bool:
		if person.is_holding(item_name): return false
		person.add_task(HarvestItem.new(priority, item_name))
		return true

class VisitBoard extends Task:
	# Person needs a task - go to the closest bulliten board, and get a task
	# there
	# TODO should they visit 'higher priority' bulliten boards, like
	# completing existing tasks? or, no, maybe all bulliten boards share data?
	# And they can give requests to folks based off max distance?
	
	func _init(_priority=0):
		super(_priority)
		name = "VisitBoard"
	
	func on_start(person: Person):
		target = Utils.find_closest_to_person(person, Bulletin)
		assert(target != null, "Could not find Bulletin")
		
	func on_perform(person: Person) -> bool:
		person.add_task(target.get_request())
		return true

class TimedTask extends Task:
	# A task that takes X ammount of time to do
	var days = 1.0
	var days_done = 0.0
	func _init(_priority=2, _target=null, _days=1.0):
		super(_priority, _target)
		days = _days
		name = "TimedTask"
		
	func on_perform_delta(delta: float, person: Person) -> bool:
		var sun = Utils.static_get_matching_node(person.get_tree().root, "Sun")
		days_done += delta * sun.get_days_per_second()
		print("Time left %s (%s-%s)"%[days-days_done, days, days_done])
		return days_done >= days

class ConstructionLabor extends TimedTask:
	# Stand around, building the thing. One day's worth of labor
	func _init(_priority=2, _target=null):
		super(_priority, _target, 1.0)
		name = "ConstructionLabor"
