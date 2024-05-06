extends Node
class_name Somatic
const NeedBasedTask = preload("res://scenes/NeedBasedTask.gd")
@onready var utils = get_node("/root/UtilsNode")

# Define needs and their default values
enum Needs {
	HUNGER, SLEEPINESS, FATIGUE, BATHROOM,
	HAPPINESS, SOCIABILITY, HYGIENE, ORDER
}

var needs = {
	# Bodily
	Needs.HUNGER: 0,
	Needs.SLEEPINESS: 0,
	Needs.FATIGUE: 0,
	Needs.BATHROOM: 0,
	# Psych
	Needs.HAPPINESS: 9,
	Needs.SOCIABILITY: 5,
	Needs.HYGIENE: 5,
	Needs.ORDER: 2,
}

# Define rates at which these needs change per day
# e.g.: hunger: 2.0 means we need to eat twice a day
var change_rates = {
	Needs.HUNGER: 2.0,
	Needs.SLEEPINESS: 1.0,
	Needs.FATIGUE: 0.5,
	Needs.BATHROOM: 1.5,
	
	Needs.HAPPINESS: -0.01, # 1000 days to make a joyful person miserable
	Needs.SOCIABILITY: -0.1, # 100 days to make a bonded person isolated
	Needs.HYGIENE: -1, # 10 days to make a clean person filthy
	Needs.ORDER: -0.1,
}

@onready var sun = get_node_or_null("/root/Main/Sun")
@onready var need_tasks = [
	NeedBasedTask.WetYourself, NeedBasedTask.PassOut, NeedBasedTask.Breather
]
@onready var person = get_parent()
func _ready():
	if sun == null:
		sun = get_node_or_null("/root/Sun")
	set_process(true)  # Ensure _process is called

func _process(delta):
	update_needs(delta)
	update_label()
	
func update_needs(delta):
	if sun == null:
		return
	var day_delta = delta * sun.get_days_per_second()
	# What is the best way to get a node we know will exist?
	for need in change_rates.keys():
		needs[need] += change_rates[need] * day_delta
		needs[need] = clamp(needs[need], 0, 10)
	check_need_tasks()

func check_need_tasks():
	# See if there are any need-based tasks that should be added to our person
	for task_type in need_tasks:
		if task_type.is_needed(person):
			var task = task_type.new()
			print("Do we have %s" % task)
			if not person.has_task(task.get_class()):
				print("Added %s" % task)
				person.add_task(task)
				
func adjust(adjustments):
	# Given a dict, make those positive/negative adjustments
	for need in adjustments.keys():
		needs[need] += adjustments[need]
		needs[need] = clamp(needs[need], 0, 10)

@onready var label = get_node("Label3D")
func update_label():
	if not Utils.debug:
		label.visible = false
		return
	
	label.visible = true
	var text = ""
	for need in needs.keys():
		var value = needs[need]
		text += "%s: %.1f\n" % [Utils.enum_name(Needs, need), value]
	label.text = text
