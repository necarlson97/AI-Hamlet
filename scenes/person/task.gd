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
	
	# path to the vecor/node target, if we have one
	if target == null:
		return
	print("Getting target vec %s %s"%[get_target_vec(), self])
	person.get_node("PathAgent").path_to_vec(get_target_vec())

func get_target_vec() -> Vector3:
	# Return the vector3 from the target
	if target is Vector3: return target
	elif target is Node3D: return target.global_position
	else:
		assert(false, "How do I get pos of %s (%s)?"%[target, typeof(target)])
		return Vector3(0, 0, 0)

func on_start(person: Person):
	# Subclass shadows if there is any logic needed on start
	pass

func perform(person: Person) -> bool:
	# Try performing, returns true only if we are done
	# TODO we could call start ourself here, but for now, just report as error
	assert(_started, "%s (%s) was not started!"%[self, person])
	return has_arrived(person) and on_perform(person)
	
func on_perform(person: Person) -> bool:
	# Subclass shadows to perform the task
	return true
	
func has_arrived(person: Person) -> bool:
	if target == null:
		return true
	return person.global_position.distance_to(get_target_vec()) < 1.0
	
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
		target = Utils.find_closest_to_person(person, item_name)
		
	func on_perform(person: Person) -> bool:
		# TODO Pick it up!
		return person.pick_up(target)
		
class MakeBlueprint extends Task:
	# Go to a target vec, and start a building there
	var building_prefab
	
	func _init(_priority=2, _target=Vector3(0, 0, 0), _building_name="outhouse"):
		super(_priority, _target)
		building_prefab  = load("res://scenes/buildings/%s.tscn"%_building_name)
		name = "MakeBlueprint"
		print("Make blueprint going to %s"%target)
		
	func on_perform(person: Person) -> bool:
		var new_building = building_prefab.instantiate()
		person.get_tree().root.add_child(new_building)
		new_building.global_position = person.global_position
		
		# Adds tasks to finish the building
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
