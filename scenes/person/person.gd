extends Node3D
class_name Person

var task_queue = PriorityQueue.new()

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
		check_task_progress()
	else:
		# Go to the nearest place to get new tasks
		task_queue.add(Task.VisitBoard.new())
		task_queue.peek().start(self)

func check_task_progress():
	# If we are where we need to be...
	if task_queue.peek().has_arrived(self):
		# Try to do the thing...
		if task_queue.peek().perform(self):
			# Done!
			task_queue.next().start(self)

func pick_up(to_hold: Node3D) -> bool:
	# Drop anything we are holding
	drop()
	$Held.add_child(to_hold)
	# TODO are there situations where we can't drop?
	return true
	
func drop():
	for c in $Held.get_children():
		# TODO I think remove_child is not needed
		$Held.remove_child(c)
		# TODO is there, like, a 'dropped' parent node?
		get_tree().root.add_child(c)

func add_task(task: Task):
	task_queue.add_task(task)

func has_task(task_type_name: String) -> bool:
	return task_queue.has_task(task_type_name)

func adjust(needs):
	return $Somatic.adjust(needs)
	
func die():
	# TODO need to make sure all tasks get returned to the bulletin.
	# Does this always make sense? Either way, probs worthwhile
	pass
