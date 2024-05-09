extends Node3D
const Needs = Somatic.Needs
# TODO eventually there will be sub types:
# outhouse (1), restroom (2-4), showers (5-6) helps hygine, bathhouse (7-10) helps hygine and happiness
# Also note that every residence is a bathroom, but only for its owners

# How much it affects people that use it (per use)
var needs = {
	Needs.BATHROOM: -8,
	Needs.HYGIENE: -1,
}

func use(person):
	person.somatic.adjust(needs)
