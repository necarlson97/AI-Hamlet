extends Node3D

var person_prefab = preload('res://scenes/person.tscn')
var building_prefab = preload('res://scenes/building.tscn')
@onready var pathfinder = get_node('Pathfinder')

func _ready():
	get_node("TimescaleLabel").text = str(Engine.time_scale)
	# For testing
	for i in range(500):
		var new_person = person_prefab.instantiate()
		add_child(new_person)
	
	var building_count = 100
	for i in range(building_count):
		var spread = 2 * building_count
		var v = Vector3(randf_range(-spread, spread), 0, randf_range(-spread, spread))
		var new = building_prefab.instantiate()
		add_child(new)
		new.global_position = v
		pathfinder.add_node(new)
		get_node("/root/UtilsNode").place_on_ground(new)
		
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_BRACKETRIGHT:
			change_slider(Engine.time_scale * 2)
		if event.keycode == KEY_BRACKETLEFT:
			change_slider(Engine.time_scale / 2)

func _process(delta):
	if true: # Utils.debug: TODO
		get_node("FPSLabel").text = str(Engine.get_frames_per_second())

func _on_h_slider_value_changed(value):
	change_slider(value)
	
func change_slider(value):
	get_node("HSlider").value = value
	get_node("TimescaleLabel").text = str(Engine.time_scale)
	Engine.time_scale = value
