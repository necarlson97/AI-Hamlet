extends Node
class_name Utils


static func get_subclasses(name: String):
	# Gets all subclasses of a given class name
	var subs = []
	for a_class in ProjectSettings.get_global_class_list():
		print("Checking %s vs %s " % [a_class.base, name])
		if a_class.base == name:
			subs.append(load(a_class.path))

static func enum_name(enum_type, value):
	for name in enum_type.keys():
		if enum_type[name] == value:
			return name.capitalize()
	return "Unknown"
