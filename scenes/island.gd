@tool
extends Node3D


@export_range(1000, 10000, 500) var map_size: int = 4000:
	set(new_value):
		map_size = new_value
		update_map()
@export_range(0, 200, 10) var height: int = 40:
	set(new_value):
		height = new_value
		update_map()
@export_range(.1, 1, .1) var collision_ratio: float = 0.1:
	set(new_value):
		collision_ratio = new_value
		create_collision()

# Normally I would use @onready with get_node, but due to tool lifecycle
# not reloading the entire file, manual relaod will have to do for now
var land;
var water;
var collision;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_nodes():
	collision = get_node("Land/StaticBody3D/CollisionShape3D")
	land = get_node("Land");
	water = get_node("Water");
	
func update_map():
	# For now, only run in editor
	if not Engine.is_editor_hint():
		return
	get_nodes()
	land.mesh.size = Vector2(map_size, map_size);
	land.mesh.material.set_shader_parameter("max_height", height);
	# Lower so water is 'in the middle of the sand layer'
	land.position.y = 2.5*float(-height)/8.0 ;
	water.mesh.size = Vector2(map_size, map_size);
	# TODO update depth fog render distance
	create_collision()

func create_collision():
	# Iterate over the heightmap, and use it to create the collison shape
	# (https://www.youtube.com/watch?v=fEG_cnRQ1HI)
	if not Engine.is_editor_hint():
		return
	get_nodes()
	var heightmap = land.mesh.material.get_shader_parameter("heightmap").get_image().duplicate()
	heightmap.clear_mipmaps()
	var col_width = int(heightmap.get_width()*collision_ratio)
	var col_depth = int(heightmap.get_height()*collision_ratio)
	collision.shape.map_width = col_width
	collision.shape.map_depth = col_depth
	var scale_ratio = float(map_size) / float(col_width)
	collision.scale = Vector3(scale_ratio, scale_ratio, scale_ratio)
	
	heightmap.resize(col_width, col_depth)
	heightmap.convert(Image.FORMAT_RF)
	var data = heightmap.get_data().to_float32_array()
	# 'Shrink' height, because we scaled to fit map, but want height to fit
	for i in data.size():
		data[i] *= float(height ) / scale_ratio
	collision.shape.map_data = data
