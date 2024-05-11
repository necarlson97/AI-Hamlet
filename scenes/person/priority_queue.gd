extends Node
class_name PriorityQueue

var tasks = []

func add(task: Task):
	if task == null: return
	var position = 0
	for existing_task in tasks:
		if existing_task.priority > task.priority:
			position += 1
		else:
			break
	tasks.insert(position, task)
	print("Inserted %s at %s"%[task, position])
	print(tasks)

func next():
	if tasks.size() > 0:
		return tasks.pop_back()
	return null
	
func peek():
	if tasks.size() > 0:
		return tasks[0]
	return null
	
func is_empty():
	return tasks == []

func clear_tasks():
	tasks.clear()

func has_task(task_type_name: String) -> bool:
	# returns true if it already has the same type of task
	for existing_task in tasks:
		if existing_task.is_class(task_type_name):
			return true
	return false
