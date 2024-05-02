extends Node
class_name PriorityQueue
const Task = preload("res://scenes/Task.gd").Task

var tasks = []

func add_task(task : Task):
	var position = 0
	for existing_task in tasks:
		if existing_task.priority < task.priority:
			position += 1
		else:
			break
	tasks.insert(position, task)

func get_next_task():
	if tasks.size() > 0:
		return tasks.pop_front()
	return null

func clear_tasks():
	tasks.clear()

func has_task(task_type_name: String) -> bool:
	# returns true if it already has the same type of task
	for existing_task in tasks:
		if existing_task.is_class(task_type_name):
			return true
	return false
