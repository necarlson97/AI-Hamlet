extends Bathroom

func _ready():
	super._ready()
	needs = {
		Somatic.Needs.BATHROOM: -8,
		Somatic.Needs.HYGIENE: -2,
		Somatic.Needs.HAPPINESS: -1,
	}
