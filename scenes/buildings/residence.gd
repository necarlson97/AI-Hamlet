extends "res://scenes/buildings/building.gd"
const Needs = Somatic.Needs

var occupants = 1

# How it effects people that sleep there (per day)
var needs = {
	Needs.SLEEPINESS: -8,
	Needs.HAPPINESS: -2,
	Needs.SOCIABILITY: -2,
	Needs.HYGIENE: -2,
	Needs.ORDER: -2,
}

func sleep(person: Person):
	# Sleep in this residence, incuring any negatives
	# TODO can we just sleep 'for a little'? E.g., make it a contintuous process?
	# Per _process? Per hour?
	person.somatic.adjust(needs)
