extends Building
class_name Bulletin
# Where the people check if they have nothing to do - 
# and where the AI / player will post their requests
# Can have levels:
# bulletin board, mailbox, post office, 
# Maybe submitting requests is shown by birds landing there, delivering letters!
# And that way it makes sense that we view the town from a flying bird!
# Can also be in the great hall / manor home, that kind of thing

var task_queue = PriorityQueue.new()

# For now, just have a list of things we tell them to build
var to_build = [
	"tent",
	"wood_lot",
	"outhouse",
]
func _ready():
	super._ready()
	# Create some tasks for what we want to build
	for build_name in to_build:
		var rand_placement = $"/root/UtilsNode".rand_ground_vec()
		task_queue.add(Task.MakeBlueprint.new(2, rand_placement, build_name))
	
func add_task(task: Task):
	# TODO could make task queue static, then make this func static
	# Tasks are then shared among all bullitens, and it reduces having to
	# find the closest and whatnot
	task_queue.add(task)

func get_request() -> Task:
	return task_queue.next()
