extends Node2D
export var bit_string_set = "1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in self.get_children():
		child.bit_string = bit_string_set
