extends Node3D
class_name Building

var items_needed = {
	"Wood": 1,
}
# Number of 'people-days' that it takes to construct
# e.g.: 1 person 10 days, 10 people 1 days
var labor_needed = 2.0

func _ready():
	# All buildings are visitalbe
	var new_pn = $"/root/PathfinderNode".create_node_at(self)
