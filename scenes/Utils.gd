extends Node3D
class_name Utils

# View debug stuff TODO
const debug = false

static func find_closest_to_person(person: Person, script_name: String, range=100.0):
	# Find the closest X script to the given person (limit range)
	# TODO dumb that this is duplicated - but either static using 'person' root,
	# or not static using autoload $Utils root
	var all = static_get_nodes_by_script(person.get_tree().root, script_name)
	var closest = find_closest(person.global_position, all)
	if closest.distance_to(person) > range:
		return null
	return closest
	
func find_closest_to(pos: Vector3, script_name: String, range=100.0):
	# Find the closest X script to the given person (limit range)
	# TODO clever caching?
	var all = static_get_nodes_by_script(get_tree().root, script_name)
	var closest = find_closest(pos, all)
	if closest.distance_to(pos) > range:
		return null
	return closest

static func find_closest(point: Vector3, arr: Array):
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
	
func get_nodes_by_script(script_name: String) -> Array:
	# Take a string of the filename, such as pathfinder.gd
	var res = static_get_nodes_by_script(get_tree().root, script_name)
	assert(res != [], "Could not find any %s"%script_name)
	return res

func get_node_by_script(script_name: String):
	var res = static_get_node_by_script(get_tree().root, script_name)
	assert(res != null, "Could not find a %s"%script_name)
	return res
			
static func static_get_nodes_by_script(node: Node, script_name: String) -> Array:
	if node.get_script() and script_name in node.get_script().get_path():
		return [node]
	var res = []
	for child in node.get_children():
		res += static_get_nodes_by_script(child, script_name)
	return res
	
static func static_get_node_by_script(node: Node, script_name: String):
	if node.get_script() and script_name in node.get_script().get_path():
		return node
	for child in node.get_children():
		var res = static_get_node_by_script(child, script_name)
		if res != null: return res
	return null

static func get_subclasses(sub_name: String):
	# Gets all subclasses of a given class name
	var subs = []
	for a_class in ProjectSettings.get_global_class_list():
		print("Checking %s vs %s " % [a_class.base, sub_name])
		if a_class.base == sub_name:
			subs.append(load(a_class.path))

static func enum_name(enum_type, value):
	for e_name in enum_type.keys():
		if enum_type[e_name] == value:
			return e_name.capitalize()
	return "Unknown"

func place_on_ground(node: Node3D):
	# Raycast to place node on ground
	var space_state = get_world_3d().direct_space_state
	var ray_length = 200
	
	var gp = node.global_position
	for vec in [Vector3(0, ray_length, 0), Vector3(0, -ray_length, 0)]:
		var query = PhysicsRayQueryParameters3D.create(gp, gp+vec)
		var result = space_state.intersect_ray(query)
		if result:
			node.global_position = result.position

static func rand_vec(spread=50.0, y_scale=0) -> Vector3:
	return Vector3(
		randf_range(-spread, spread),
		randf_range(-spread, spread) * y_scale,
		randf_range(-spread, spread)
	)
