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

func _ready():
	super._ready()
	task_queue.add(random_build_request())

func get_request() -> Task:
	# TODO normally, we will have a priority queue, but for now,
	# just make a random build order
	task_queue.add(random_build_request())
	return task_queue.next()
	
func random_build_request() -> Task:
	# TODO add a task to build something at a random location
	var rand_placement = $"/root/UtilsNode".get_ground_vec(Utils.rand_vec())
	return Task.MakeBlueprint.new(2, rand_placement)
