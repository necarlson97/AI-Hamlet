extends Node
class_name Sun

# Configurable properties
var seconds_per_day = float(60 * 10)  # Default length of a day in seconds
# TODO should probs be 'time of day', and a 0-1 range
var _current_time = 0.0  # Current time in seconds within the day
var days_elapsed = 0  # Total number of full days elapsed

signal day_passed(days_elapsed)  # Signal to alert other parts of the game when a day passes
signal time_updated(current_time, days_elapsed)  # Signal to provide time updates

func _process(delta):
	update_time(delta)
	update_label()

func update_time(delta):
	_current_time += delta
	if _current_time >= seconds_per_day:
		_current_time = fmod(_current_time, seconds_per_day)
		days_elapsed += 1
		emit_signal("day_passed", days_elapsed)
	emit_signal("time_updated", _current_time, days_elapsed)

func get_time_of_day() -> float:
	return _current_time / seconds_per_day

func get_days_elapsed() -> int:
	return days_elapsed
	
func get_hour_of_day() -> int:
	return int(get_time_of_day() * 24)

func get_days_per_second():
	return 1.0 / seconds_per_day
	
func update_label():
	if not Utils.debug:
		$Label3D.visible = false
		return
	
	$Label3D.visible = true
	var text = ""
	# For now, just days/hours. Maybe in the future, months and whatnot
	# or maybe seasons?
	text += "Day %s, Hour %s (%0.1f)\n" % [get_days_elapsed(), get_hour_of_day(), get_time_of_day()]
	$Label3D.text = text
