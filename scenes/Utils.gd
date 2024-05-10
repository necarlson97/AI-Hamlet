extends Node3D
class_name Utils

# View debug stuff TODO
const debug = true

static func find_closest_to_person(person: Person, script, max_range=100.0):
	# Find the closest X script to the given person (limit range)
	# TODO dumb that this is duplicated - but either static using 'person' root,
	# or not static using autoload $"/root/UtilsNode" root
	var all = []
	if script is String:
		all = static_get_nodes_by_script_name(person.get_tree().root, script)
	else:
		all = static_get_nodes_by_script(person.get_tree().root, script)
	var closest = find_closest_in_array(person.global_position, all)
	
	if closest == null: return null
	if closest.global_position.distance_to(person.global_position) > max_range: return null
	return closest
	
func find_closest_to(pos: Vector3, script, max_range=100.0):
	# Find the closest X script to the given person (limit range)
	# TODO clever caching?
	var all = Utils.static_get_nodes_by_script(get_tree().root, script)
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

# Functions for finding by script type
func get_nodes_by_script(script: Script) -> Array:
	# Take a string of the filename, such as pathfinder.gd
	var res = Utils.static_get_nodes_by_script(get_tree().root, script)
	assert(res != [], "Could not find any %s"%script)
	return res
func get_node_by_script(script: Script):
	var res = Utils.static_get_node_by_script(get_tree().root, script)
	assert(res != null, "Could not find a %s"%script)
	return res
static func static_get_nodes_by_script(node: Node, script: Script) -> Array:
	if is_instance_of(node, script):
		return [node]
	var res = []
	for child in node.get_children():
		res += Utils.static_get_nodes_by_script(child, script)
	return res
static func static_get_node_by_script(node: Node, script: Script):
	if is_instance_of(node, script):
		return node
	for child in node.get_children():
		var res = Utils.static_get_node_by_script(child, script)
		if res != null: return res
	return null

# Functions for finding by script name
func get_nodes_by_script_name(script_name: String) -> Array:
	# Take a string of the filename, such as pathfinder.gd
	var res = Utils.static_get_nodes_by_script_name(get_tree().root, script_name)
	assert(res != [], "Could not find any %s"%script_name)
	return res
func get_node_by_script_name(script_name: String):
	var res = Utils.static_get_node_by_script_name(get_tree().root, script_name)
	assert(res != null, "Could not find a %s"%script_name)
	return res
static func static_get_nodes_by_script_name(node: Node, script_name: String) -> Array:
	if node.get_script() and script_name in node.get_script().get_path():
		return [node]
	var res = []
	for child in node.get_children():
		res += Utils.static_get_nodes_by_script_name(child, script_name)
	return res
static func static_get_node_by_script_name(node: Node, script_name: String):
	if node.get_script() and script_name in node.get_script().get_path():
		return node
	for child in node.get_children():
		var res = Utils.static_get_node_by_script_name(child, script_name)
		if res != null: return res
	return null

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
