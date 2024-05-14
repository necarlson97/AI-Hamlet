extends Task
class_name TaskNeedBased
const Needs = preload("res://scenes/person/somatic.gd").Needs

# Thresholds  (e.g.: Needs.BATHROOM: 9)
# Note, they are all required
static var greater_than = {}
static var less_than = {}

func _init(_priority=2, _target=null):
	super(_priority, _target)
	name = "TaskNeedBased"
	
static func is_needed(person: Person):
	for key in greater_than.keys():
		var value = greater_than[key]
		if person.get_node("Somatic").needs[key] < value:
			return false
	for key in less_than.keys():
		var value = greater_than[key]
		if person.get_node("Somatic").needs[key] > value:
			return false
	return true


# TODO for most/all of these, we want particles and lying down or whatever.

class WetYourself extends TaskNeedBased:
	# its an emergency, you weren't able to find a bathroom in time
	func _init():
		greater_than = {Needs.BATHROOM: 9}
		super(5)
		name = "WetYourself"

	func on_perform(person: Node):
		# Logic for handling emergency situation
		print("Emergency! No outhouse found in time for: ", person.name)
		
		# Effects that this has on person's mentality
		person.adjust({
			Needs.BATHROOM: -10,
			Needs.HAPPINESS: -3,
			Needs.SOCIABILITY: -2,
			Needs.HYGIENE: -6,
			Needs.ORDER: -2,
		})

class PassOut extends TaskNeedBased:
	# its an emergency, you weren't able to find a bed in time
	func _init():
		greater_than = {Needs.SLEEPINESS: 9}
		super(5)
		name = "PassOut"

	func on_perform(person: Node):
		# Logic for handling emergency situation
		print("Emergency! No bed found in time for: ", person.name)
		
		# Effects that this has on person's mentality
		person.get_somatic().adjust({
			Needs.SLEEPINESS: -10,
			Needs.HAPPINESS: -6,
			Needs.SOCIABILITY: -1,
			Needs.HYGIENE: -6,
		})

class Breather extends TaskNeedBased:
	# its an emergency, you weren't able to find a bed in time
	func _init():
		greater_than = {Needs.FATIGUE: 9}
		super(5)
		name = "Breather"

	func on_perform(person: Node):
		# Logic for handling emergency situation
		print("Emergency! Need to take a rest: ", person.name)
		
		# Effects that this has on person's mentality
		person.get_somatic().adjust({
			Needs.FATIGUE: -10,
			Needs.SOCIABILITY: -3,
		})
