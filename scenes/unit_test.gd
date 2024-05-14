extends Node3D

# used to test things like the Utils funcs
func _ready():
	var outhouse_prefab = preload("res://scenes/buildings/outhouse.tscn")
	var outhouse = outhouse_prefab.instantiate()
	var tent_prefab = preload("res://scenes/buildings/tent.tscn")
	var tent = tent_prefab.instantiate()
	add_child(tent)
	add_child(outhouse)
	
	assert(Utils.matches_class(outhouse, Outhouse))
	assert(Utils.matches_class(outhouse, "Outhouse"))
	assert(Utils.matches_class(outhouse, "Bathroom"))
	assert(Utils.matches_class(outhouse, Bathroom))
	assert(Utils.matches_class(outhouse, "Building"))
	assert(Utils.matches_class(outhouse, Building))
	
	assert(not Utils.matches_class(outhouse, "Tent"))
	assert(not Utils.matches_class(outhouse, "Residence"))
	assert(not Utils.matches_class(outhouse, Residence))
	assert(not Utils.matches_class(outhouse, "Wood"))
	assert(not Utils.matches_class(outhouse, Wood))
	
	assert(Utils.matches_class(tent, "Residence"))
	assert(Utils.matches_class(tent, Residence))
	assert(Utils.matches_class(tent, "Building"))
	assert(Utils.matches_class(tent, Building))
	
	assert(not Utils.matches_class(tent, "Outhouse"))
	assert(not Utils.matches_class(tent, Outhouse))
	assert(not Utils.matches_class(tent, "Bathroom"))
	assert(not Utils.matches_class(tent, Bathroom))
	
	var wood_prefab = preload("res://scenes/crafting/wood.tscn")
	var wood = wood_prefab.instantiate()
	add_child(wood)
	assert(Utils.matches_class(wood, "Wood"))
	assert(Utils.matches_class(wood, Wood))
	assert(Utils.matches_class(wood, "CraftItem"))
	assert(Utils.matches_class(wood, CraftItem))
	
	assert($"/root/UtilsNode".get_matching_node(Outhouse) == outhouse)
	assert($"/root/UtilsNode".get_matching_node("Outhouse") == outhouse)
	assert($"/root/UtilsNode".get_matching_nodes(Bathroom) == [outhouse])
	assert($"/root/UtilsNode".get_matching_nodes("Bathroom") == [outhouse])
	
	assert($"/root/UtilsNode".get_matching_nodes(Residence) == [tent])
	assert($"/root/UtilsNode".get_matching_nodes("Residence") == [tent])
	
	assert($"/root/UtilsNode".get_matching_nodes("Building") == [tent, outhouse])
	assert($"/root/UtilsNode".get_matching_nodes(Building) == [tent, outhouse])
	
	assert($"/root/UtilsNode".get_matching_node("Wood") == wood)
	assert($"/root/UtilsNode".get_matching_node(Wood) == wood)
	assert($"/root/UtilsNode".get_matching_node("CraftItem") == wood)
	assert($"/root/UtilsNode".get_matching_node(CraftItem) == wood)
	
	assert($"/root/UtilsNode".get_matching_nodes("Wood") == [wood])
	assert($"/root/UtilsNode".get_matching_nodes(Wood) == [wood])
	assert($"/root/UtilsNode".get_matching_nodes("CraftItem") == [wood])
	assert($"/root/UtilsNode".get_matching_nodes(CraftItem) == [wood])
	
	assert(Utils.static_get_matching_node(self, "Sun") == $Sun)
	assert(Utils.static_get_matching_node(self, Sun) == $Sun)
	assert(Utils.static_get_matching_nodes(self, "Sun") == [$Sun])
	assert(Utils.static_get_matching_nodes(self, Sun) == [$Sun])
	
