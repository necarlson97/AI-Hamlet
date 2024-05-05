extends Node3D
class_name Pathfinder

# The points we want to 'end' at 
var destinations: Array[PathfinderNode] = []

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
	
	func _to_string() -> String:
		return "%s->%s (%.2f)"%[from, to, get_cost()]

func _ready():
	test_network()
	calcualte_mst()
	
func test_network():
	# For testing purposes
	for child in get_children():
		if "Destination" in child.name:
			destinations.append(create_node(child))

func _process(delta):
	# For debugging
	for edge in mst:
		DebugDraw3D.draw_line(edge.from.global_position, edge.to.global_position, Color.WHITE_SMOKE)

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

func add_edges(node):
	visited[node] = true
	for target in destinations:
		if not visited.has(target):
			edges.append(PathEdge.new(node, target))
	edges.sort_custom(edge_sort)

func edge_sort(a, b):
	return a.get_cost() < b.get_cost()
	
func create_node(pos: Node3D) -> PathfinderNode:
	var new = PathfinderNode.create(pos)
	add_child(new)
	return new

# memoize intermediate travels through the mst to make future calls faster
# TODO need to dirty every time we edit the tree
var _path_cache = {}
func find_path_to_point(from: Vector3, to: Vector3) -> Array[Node3D]:
	# Given a from and to vector:
	# Find the closest 'entry' and 'exit' PathNodes
	# (can be leaf or inner node)
	# then use those to find (and return) the path through the mst
	# from entry -> exit
	var entry_node = find_closest_node(from)
	var exit_node = find_closest_node(to)

	if not entry_node or not exit_node:
		print("No entry or exit node found.")
		return []

	var entry_key = entry_node.get_instance_id()
	var exit_key = exit_node.get_instance_id()
	var path_key = str(entry_key) + "->" + str(exit_key)

	# Check if the path is already cached
	if _path_cache.has(path_key):
		print("Using cached path")
		return _path_cache[path_key]

	# Find path in MST from entry to exit
	var path = find_path_in_mst(entry_node, exit_node)
	_path_cache[path_key] = path  # Cache the newly found path
	return path

func find_path_in_mst(start_node: PathfinderNode, end_node: PathfinderNode) -> Array[Node3D]:
	var queue = []
	var came_from = {}
	queue.push_back(start_node)
	came_from[start_node] = null

	# Breadth-first search (BFS) to find the path
	while queue.size() > 0:
		var current = queue.pop_front()
		if current == end_node:
			break
		for edge in mst:
			if edge.from == current and not came_from.has(edge.to):
				queue.push_back(edge.to)
				came_from[edge.to] = current
			elif edge.to == current and not came_from.has(edge.from):
				queue.push_back(edge.from)
				came_from[edge.from] = current

	# Backtrack to find the path
	var path: Array[Node3D] = []
	var step = end_node
	while step != null:
		path.push_front(step)
		step = came_from[step]
	return path

func find_closest_node(point: Vector3) -> PathfinderNode:
	var closest_node = null
	var min_distance = INF
	for node in destinations:
		var dist = node.global_position.distance_to(point)
		if dist < min_distance:
			min_distance = dist
			closest_node = node
	return closest_node
