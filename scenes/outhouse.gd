extends Bathroom

func _ready():
	needs = {
		Somatic.Needs.BATHROOM: -8,
		Somatic.Needs.HYGIENE: -2,
		Somatic.Needs.HAPPINESS: -1,
	}
