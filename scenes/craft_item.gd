extends Node3D

# TODO what is our setup here? Maybe an instance file per crafting item type,
# then it has the enum states 'raw' and 'processed'? Is this the best
# way to break this up?
@export var raw: MeshInstance3D;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
