extends Node

class_name Sun

# Configurable properties
var seconds_per_day = 60 * 10  # Default length of a day in seconds
# TODO should probs be 'time of day', and a 0-1 range
var current_time = 0  # Current time in seconds within the day
var days_elapsed = 0  # Total number of full days elapsed
var time_scale = 1.0  # Factor to speed up or slow down time

signal day_passed(days_elapsed)  # Signal to alert other parts of the game when a day passes
signal time_updated(current_time, days_elapsed)  # Signal to provide time updates

func _ready():
	set_process(true)  # Start processing time updates

func _process(delta):
	update_time(delta * time_scale)

func update_time(delta):
	current_time += delta
	if current_time >= seconds_per_day:
		current_time %= seconds_per_day
		days_elapsed += 1
		emit_signal("day_passed", days_elapsed)
	emit_signal("time_updated", current_time, days_elapsed)

func set_time_scale(scale):
	time_scale = scale

func get_time_of_day():
	return current_time

func get_days_elapsed():
	return days_elapsed

func get_days_per_second():
	return 1.0 / seconds_per_day
