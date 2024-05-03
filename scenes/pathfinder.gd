extends Node3D

const PathfinderNodePrefab = preload("res://scenes/pathfinder_node.tscn")

# The points we want to 'end' at 
@export var destinations: Array[PathfinderNode] = []

class PathEdge:
	var from: PathfinderNode
	var to: PathfinderNode
	func _init(_from, _to):
		from = _from
		to = _to
	
	var _cost = -1.0
	func get_cost():
		if _cost == -1.0:
			_cost = from.distance_to(to)
		return _cost
	
	func _to_string():
		return "%s->%s (%.2f)"%[from, to, get_cost()]

func _ready():
	# For testing purposes
	for child in get_children():
		destinations.append(PathfinderNode.new(child))
	calcualte_mst()	

var mst = []
var visited = {}
var edges = []
func calcualte_mst(max_length=40.0):
	# Calcualte the 'minimum span tree' between all destinations
	add_edges(destinations[0])
	
	while edges.size() > 0:
		var edge = edges.pop_front()
		var to_node = edge.to

		if not visited.has(to_node):
			mst.append(edge)
			add_edges(to_node)
			
	# For debugging
	print("MST:")
	for edge in mst:
		print(edge)
		Utils.line(mst.from.global_position, mst.to.global_position)
	
func add_edges(node):
	visited[node] = true
	for target in destinations:
		if not visited.has(target):
			edges.append(PathEdge.new(node, target))
	edges.sort_custom(edge_sort)

func edge_sort(a, b):
	return a.get_cost() - b.get_cost()

func find_path_to_point(from: Vector3 , to: Vector3) -> Array[Node3D]: 
	# Given a from and to vector:
	# Find the closest 'entry' and 'exit' PathNodes
	# (can be leaf or inner node)
	# then return the path entry -> exit
	return []
