extends Bathroom
class_name Outhouse

func _ready():
	super._ready()
	needs = {
		Somatic.Needs.BATHROOM: -8,
		Somatic.Needs.HYGIENE: -2,
		Somatic.Needs.HAPPINESS: -1,
	}
