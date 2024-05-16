extends Building
class_name Storage

@export var item_name: String = "Wood"
var capacity: int

func _ready():
	assert(item_name, "Storage item name cannot be nil (%s)"%item_name)
	capacity = $MeshInstance3D.get_children().size()
	# For now, just tell a bulletin to have us filled
	# TODO how should we really handle bulliten tasks?
	var bulliten = $"/root/UtilsNode".get_matching_node(Bulletin)
	# TODO could have, like, a high priority to fill halfway,
	# then a low priority to fill fully, or something
	for i in range(capacity):
		bulliten.task_queue.add(fill_task())
		
	labor_needed = 0
	

var in_storage = []
func store_item(item) -> bool:
	# TODO physicaly put as a child of the empty, right?
	# TODO eh wait this is fucked, can't extend from building and also
	# have add_item. So maybe blueprint needs to be its own scene thing
	if in_storage.size() >= capacity:
		return false
	Utils.set_parent(item, self)
	# TODO parent and set loc to child
	item.position = Vector3(0, 0, 0)
	in_storage.append(item)
	return true

func fill_task() -> Task:
	# If we need to fill this storage, do that
	# (BringItemTo becomes GetItem becomes HarvestItem)
	# TODO do we need to check to make sure we are not just
	# stealing from other storage?
	# Or a 'HarvestItemTo' task?
	return Task.HarvestItemTo.new(2, self, item_name)
