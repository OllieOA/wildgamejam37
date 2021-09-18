#extends KinematicBody2D
extends Bit

var bit_string = "0"
var frame_to_use

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bit_particles = load("res://Assets/Art/Units/unit_mineable_particle_base.png")
	bit_dict = {
		"0110": 0,
		"1": 1,
		"0": 2,
		"10": 3
	}
	
	frame_to_use = bit_dict[bit_string]
	sprite.frame = frame_to_use
