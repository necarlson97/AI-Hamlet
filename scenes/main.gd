extends Node3D

var person_prefab = preload('res://scenes/person/person.tscn')
var building_prefab = preload('res://scenes/buildings/building.tscn')

func _ready():
	get_node("TimescaleLabel").text = str(Engine.time_scale)
	# For testing
	var person_count = 1
	for i in range(person_count):
		var new_person = person_prefab.instantiate()
		add_child(new_person)
		
	# TODO for now, any buildings we start with, start built
	for c in get_children():
		if c is Building:
			c.finish_build()
	
	var building_count = 0
	for i in range(building_count):
		var spread = 2 * building_count
		var v = Utils.rand_vec(spread)
		var new = building_prefab.instantiate()
		add_child(new)
		new.global_position = v
		$"/root/UtilsNode".place_on_ground(new)
		
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
