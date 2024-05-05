extends Node3D

var path: Array[Node3D] = []
@onready var utils = get_node("/root/UtilsNode")
@onready var pathfinder: Pathfinder = utils.get_node_by_script("pathfinder.gd")

var next_waypoint: Node3D = null
var last_waypoint: Node3D = null

var speed = 10.0;

var t = 0.0;
func _process(delta):
	# For now, just choose random points, and go there
	t += delta * speed
	if path == []:
		var target = choose_random_destination()
		path = pathfinder.find_path_to_point(global_position, target.global_position)
	if next_waypoint == null or global_position.distance_to(next_waypoint.global_position) < 0.01:
		last_waypoint = next_waypoint
		next_waypoint = path.pop_front()
		t = 0
	if last_waypoint == null:
		last_waypoint = self  # Creates weird slow lerp on first, but whatever
	
	global_position = global_position.move_toward(next_waypoint.global_position, delta * speed)
	
func choose_random_destination() -> Node3D:
	return pathfinder.destinations.pick_random()
