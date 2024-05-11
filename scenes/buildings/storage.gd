extends Building
class_name Storage

@export var item_name = "Wood"
var capacity: int

func _ready():
	capacity = $MeshInstance3D.get_children().size()
	# For now, just tell a bulletin to have us filled
	# TODO how should we really handle bulliten tasks?
	var bulliten = $"/root/UtilsNode".get_node_by_script(Bulletin)
	for i in range(capacity):
		bulliten.task_queue.add(fill_task())

var in_storage = []
func store_item(item):
	# TODO physicaly put as a child of the empty, right?
	# TODO eh wait this is fucked, can't extend from building and also
	# have add_item. So maybe blueprint needs to be its own scene thing
	if in_storage.size() >= capacity:
		return false
	in_storage.append(item)
	return true

func fill_task() -> Task:
	# If we need to fill this storage, do that
	# TODO actually needs to be a 'ProduceWood' or whatever
	# TODO or is that logic inside of 'get item'? Probs
	assert(false, "Create wood or whatever, not just bring")
	return Task.BringItemTo.new(2, self, item_name)
	
