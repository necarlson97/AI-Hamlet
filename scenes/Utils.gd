extends Node
class_name Utils

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
