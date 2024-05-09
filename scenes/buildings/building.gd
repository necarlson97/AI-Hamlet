extends Node3D

# TODO enum from resources
var costs = {
	Wood: 1,
}
# Number of 'people-days' that it takes to construct
# e.g.: 1 person 10 days, 10 people 1 days
var construction = 10

# TODO would it be easier, instead of children having to keep track of this,
# to have a seperate 'Blueprint' which just looks like the building,
# has no functionality, but can get replaced?
var completed = false

func get_build_task():
	# If not yet built, get a task to continue building it
	# TODO
	pass

func perform_build_step(person: Person, item: CraftItem):
	# TODO put the item into the building
	pass
