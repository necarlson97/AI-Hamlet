extends Node3D
class_name Utils

# View debug stuff TODO
const debug = true

static func find_closest_to_person(person: Person, script, max_range=100.0):
	# Find the closest X script to the given person (limit range)
	# TODO dumb that this is duplicated - but either static using 'person' root,
	# or not static using autoload $"/root/UtilsNode" root
	var all = []
	all = static_get_matching_nodes(person.get_tree().root, script, true)
	var closest = find_closest_in_array(person.global_position, all)
	
	if closest == null: return null
	if closest.global_position.distance_to(person.global_position) > max_range: return null
	return closest
	
func find_closest_to(pos: Vector3, script, max_range=100.0):
	# Find the closest X script to the given person (limit range)
	# TODO clever caching?
	var all = Utils.static_get_matching_nodes(get_tree().root, script)
	var closest = Utils.find_closest_in_array(pos, all)
	
	if closest == null: return null
	if closest.global_position.distance_to(pos) > max_range: return null
	return closest

static func find_closest_in_array(point: Vector3, arr: Array):
	var closest_node = null
	var min_distance = INF
	for node in arr:
		var dist = node.global_position.distance_to(point)
		# Not all objects have a concept of being 'claimed',
		# but those that do, claimed doesn't show up in search
		var claimed = node.has_method("is_claimed") and node.is_claimed()
		if dist < min_distance and not claimed:
			min_distance = dist
			closest_node = node
	return closest_node

# Functions for finding by script or class name (see 'matches_class')
func get_matching_node(script, allow_null=false):
	return Utils.static_get_matching_node(get_tree().root, script, allow_null)
func get_matching_nodes(script, allow_empty=false) -> Array:
	return Utils.static_get_matching_nodes(get_tree().root, script, allow_empty)
static func static_get_matching_node(node: Node, script, allow_null=false):
	var res = Utils._static_get_matching_node(node, script)
	assert(res != null or allow_null, "Could not find a %s (%s) = %s"%[script, node, res])
	return res
static func static_get_matching_nodes(node: Node, script, allow_empty=false) -> Array:
	var res = Utils._static_get_matching_nodes(node, script)
	assert(res != [] or allow_empty, "Could not find a %s (%s)"%[script, node])
	return res
static func _static_get_matching_node(node: Node, script):
	if Utils.matches_class(node, script): return node
	for child in node.get_children():
		var res = Utils._static_get_matching_node(child, script)
		if res != null: return res
	return null
static func _static_get_matching_nodes(node: Node, script) -> Array:
	if Utils.matches_class(node, script): return [node]
	var res = []
	for child in node.get_children():
		res += Utils._static_get_matching_nodes(child, script)
	return res

static func get_subclasses(sub_name: String):
	# Gets all subclasses of a given class name
	var subs = []
	for a_class in ProjectSettings.get_global_class_list():
		if a_class.base == sub_name:
			subs.append(load(a_class.path))

static func enum_name(enum_type, value):
	for e_name in enum_type.keys():
		if enum_type[e_name] == value:
			return e_name.capitalize()
	return "Unknown"

func get_ground_vec(pos: Vector3) -> Vector3:
	# Raycast up/down to island ground
	var space_state = get_world_3d().direct_space_state
	var ray_length = 200
	
	for vec in [Vector3(0, ray_length, 0), Vector3(0, -ray_length, 0)]:
		var query = PhysicsRayQueryParameters3D.create(pos, pos+vec)
		var result = space_state.intersect_ray(query)
		if result: return result.position
	return pos
			
func place_on_ground(node: Node3D):
	# Raycast to place node on ground
	node.global_position = get_ground_vec(node.global_position)

static func rand_vec(spread=50.0, y_scale=0) -> Vector3:
	return Vector3(
		randf_range(-spread, spread),
		randf_range(-spread, spread) * y_scale,
		randf_range(-spread, spread)
	)

static func sum(arr: Array):
	if arr == []: return 0
	return arr.reduce(func(accum, number): return accum + number)
	
func rand_ground_vec(spread=30.0, min_y=1.0) -> Vector3:
	# Get a random vector that is an actual spot on the islands ground,
	# and not below the min_y (usually just not below water at 0)
	while true:
		var v = get_ground_vec(Utils.rand_vec(spread))
		if v.y > min_y: return v
	assert(false, "Why were we unable to get ground vec? %s %s"%[spread, min_y])
	return Vector3(0, 0, 0)

static func matches_class(obj, klass) -> bool:
	# A more permissive version of is class that checks:
	# * If obj is of the class (exact or subclass)
	# * If obj matches the class_name (e.g., a string was passed in)
	# * If obj is a node that has a script with the class
	# * If obj is a node that has a script with the class_name
	if klass is String: return matches_class_name(obj, klass)
	else: return matches_class_type(obj, klass)

static func matches_class_name(obj, klass: String) -> bool:
	# Check if the object itself matches the class or any subclass
	if obj.is_class(klass): return true
	# Traverse through attached script and its base scripts
	var script = obj.get_script()
	while script:
		if klass.to_snake_case() in script.get_path(): return true
		script = script.get_base_script()
	return false
	
static func matches_class_type(obj, klass):
	# Check if the object is an instance of the class or inherits from it
	return is_instance_of(obj, klass)
	
static func set_parent(node, parent, reset_pos=true):
	# Like add_child or reparent, but don't care if it had a parent before
	if node.get_parent(): node.reparent(parent)
	else: parent.add_child(node)
	# Normally, we want to set the position to parent
	if reset_pos: node.position = Vector3(0, 0, 0)
