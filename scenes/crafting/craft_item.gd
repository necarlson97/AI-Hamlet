extends Node3D
class_name CraftItem

# TODO what is our setup here? Maybe an instance file per crafting item type,
# then it has the enum states 'raw' and 'processed'? Is this the best
# way to break this up?
@export var raw: MeshInstance3D
@export var processed: MeshInstance3D
# TODO depsit, factory, different levels of upgrading, etc

# 'Person' is responsible for holding / not holding item (their 'inventory')
# However, 'claiming' allows them to 'put a hold' on
# an item - so others don't swipe it while they are on the way
# (so that is tracked here)
var claimant: Person = null
func claim(person: Person):
	# TODO make sure they are still alive and claiming and whatnot
	claimant = person
func is_claimed() -> bool:
	return claimant != null

# Could be enum if there is more, but for now, just raw/processed
var is_refined = false
func refine(person: Person, additional=0):
	if additional > 0:
		assert(additional == 0, "TODO not implemented making more yet")
	is_refined = true
	$raw.visible = false
	$processed.visible = true
