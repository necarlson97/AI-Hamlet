extends Node3D
class_name Person
const Task = preload("res://scenes/Task.gd").Task

@onready var somatic = get_node("Somatic")
var task_queue = PriorityQueue.new()

var role = ""
#var home : Home = null

func _init(_role=null):
	role = _role

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
