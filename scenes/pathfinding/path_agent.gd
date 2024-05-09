extends Node3D

var path: Array[Node3D] = []

var next_waypoint: Node3D = null
var last_waypoint: Node3D = null

# TODO for testing
var speed = 2.0

func _process(delta):
	# Move toward next waypoint
	if path == []:
		return

	if next_waypoint == null or is_close_enough():
		last_waypoint = next_waypoint
		next_waypoint = path.pop_front()
	if last_waypoint == null:
		last_waypoint = self
	get_parent().global_position = global_position.move_toward(next_waypoint.global_position, delta * speed)
	
func path_to(new_target: Node3D):
	path = $PathfinderNode.find_path_to_point(global_position, new_target.global_position)

func path_to_vec(new_target_vec: Vector3):
	path = $PathfinderNode.find_path_to_point(global_position, new_target_vec)

func is_close_enough():
	# Because we snap y to the island collider, we want to
	# only check x & z
	var my_gp = global_position * Vector3(1, 0, 1)
	var wp_gp = next_waypoint.global_position * Vector3(1, 0, 1)
	return my_gp.distance_to(wp_gp) < 0.1
	
func choose_random_destination() -> Node3D:
	var d = $PathfinderNode.destinations.pick_random()
	return d

