class Task:
	var priority : int
	var target = null  # Can be used to specify a resource or location

	# highest priority is, for now, 5
	# 5 = running from danger, pissing yourself, stealing food to survive, etc
	# 4 = finishing the task you are doing (?)
	# 3 = resolving somatic noramlly, like finding an outhouse, or getting a meal
	# 2 = starting work on something new
	# 1 = having fun, socalizing
	# 0 = wandering, whatever
	func _init(_priority=2, _target=null):
		priority = _priority
		target = _target

	# Abstract method to perform the task
	func perform(person: Node):
		pass
		
	func _to_string():
		return "(%s) %s - %s" % [priority, get_class(), target]

