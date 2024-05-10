extends Node3D

var path: Array[Node3D] = []

# TODO for testing
var speed = 2.0

func _process(delta):
	# Move toward next waypoint
	if path == []: return
	if is_close_enough():
		path.pop_front()
	if path == []: return
	get_parent().global_position = global_position.move_toward(path[0].global_position, delta * speed)
	
func path_to(new_target: Node3D):
	path = $"/root/PathfinderNode".find_path_to_point(global_position, new_target.global_position)
	# make the last node the thing itself, which allows us to chase it if it is moving
	path.append(new_target)

func path_to_vec(new_target_vec: Vector3):
	path = $"/root/PathfinderNode".find_path_to_point(global_position, new_target_vec)
	# Make a non-moving final node to go to
	# TODO don't need this if the end goal is a building itself, but whatevs
	path.append($"/root/PathfinderNode".create_node(new_target_vec))
	print("Pathing to %s"%new_target_vec)

func is_close_enough():
	# Because we snap y to the island collider, we want to
	# only check x & z
	var my_gp = global_position * Vector3(1, 0, 1)
	var wp_gp = path[0].global_position * Vector3(1, 0, 1)
	return my_gp.distance_to(wp_gp) < 0.1
	
func choose_random_destination() -> Node3D:
	var d = $"/root/PathfinderNode".destinations.pick_random()
	return d

