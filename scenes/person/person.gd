extends Node3D
class_name Person

var task_queue: PriorityQueue = PriorityQueue.new()

var role = ""
#var home : Home = null

func _ready():
	# For a little variance
	# TODO could be dependent on somatic
	if $PathAgent:
		$PathAgent.speed *= randf_range(0.9, 1.1)

func _process(delta):
	# TODO is this the best way to structure this?
	if task_queue.peek():
		check_task_progress(delta)
	else:
		# Go to the nearest place to get new tasks
		task_queue.add(Task.VisitBoard.new())
		task_queue.peek().start(self)
	update_label()

func check_task_progress(delta):
	# If we are where we need to be...
	var current_task = task_queue.peek()
	if current_task.perform(delta, self):
		# Done!
		print("Tasks:")
		print(task_queue.tasks)
		# We need to make sure we remove the completed task,
		# as we might've added new tasks infront of this one
		task_queue.remove(current_task)
		if task_queue.peek():
			task_queue.peek().start(self)

func pick_up(to_hold: Node3D) -> bool:
	# Drop anything we are holding
	drop()
	Utils.set_parent(to_hold, $Held)
	# TODO are there situations where we can't drop?
	return true
	
func drop() -> Node3D:
	var held = get_held()
	if held == null: return null
	# TODO I think remove_child is not needed
	$Held.remove_child(held)
	# TODO is there, like, a parent node for dropped stuff?
	get_tree().root.add_child(held)
	return held
	
func get_held() -> Node3D:
	# For now, we are going to limit inventory to 1 to simplify
	if $Held.get_children() == []:
		return null
	assert($Held.get_children().size() == 1)
	return $Held.get_children()[0]

func is_holding(item_name) -> bool:
	return get_held() and Utils.matches_class(get_held(), item_name)

func add_task(task: Task):
	task_queue.add(task)
	# If this new task just became the most important, we need to
	# start it immediatly
	# TODO not sure if this is the best place to handle this
	if task_queue.tasks[0] == task:
		task.start(self)

func has_task(task_type_name: String) -> bool:
	return task_queue.has_task(task_type_name)

func adjust(needs):
	return $Somatic.adjust(needs)
	
func die():
	# TODO need to make sure all tasks get returned to the bulletin.
	# Does this always make sense? Either way, probs worthwhile
	pass

func update_label():
	if not Utils.debug:
		$Label3D.visible = false
		return
	
	$Label3D.visible = true
	var text = ""
	text += "Held: %s\n" % get_held()
	text += "Pos: %s\n" % global_position.round()
	text += "Path: %s\n" % $PathAgent.path.size()
	for p in $PathAgent.path:
		text += " - %s (%s)\n" % [p, p.global_position.round()]
		
	text += "Tasks: %s\n" % task_queue.tasks.size()
	for task in task_queue.tasks:
		text += " - %s (%s)\n" % [task, task.has_arrived(self)]
	$Label3D.text = text
