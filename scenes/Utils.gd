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

static func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
