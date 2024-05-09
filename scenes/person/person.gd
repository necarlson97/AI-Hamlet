extends Node3D
class_name Person
const Task = preload("res://scenes/Task.gd").Task

@onready var somatic = get_node("Somatic")
@onready var path_agent = get_node("PathAgent")
var task_queue = PriorityQueue.new()

var role = ""
#var home : Home = null

func _ready():
	# For a little variance
	# TODO could be dependent on somatic
	if path_agent:
		path_agent.speed *= randf_range(0.9, 1.1)

func _process(delta):
	var current_task = task_queue.get_next_task()
	if current_task:
		current_task.perform(self)

func move_to(location):
	print("Moving to location: ", location)

func add_task(task: Task):
	task_queue.add_task(task)

func has_task(task_type_name: String) -> bool:
	return task_queue.has_task(task_type_name)
