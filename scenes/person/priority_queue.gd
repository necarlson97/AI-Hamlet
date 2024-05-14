extends Node
# TODO rename TaskQueue
class_name PriorityQueue

var tasks = []

func add(task: Task):
	if task == null: return
	var position = 0
	for existing_task in tasks:
		# Note: if the priority is equal, we want the new task to take over.
		# that way, we can say: do x - oh you need item first? Get item
		# without creeping task priority up
		if existing_task.priority > task.priority:
			position += 1
		else:
			break
	tasks.insert(position, task)

func next():
	if tasks.size() > 0:
		return tasks.pop_at(0)
	return null
	
func peek():
	if tasks.size() > 0:
		return tasks[0]
	return null
	
func remove(task: Task):
	tasks.erase(task)
	
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
