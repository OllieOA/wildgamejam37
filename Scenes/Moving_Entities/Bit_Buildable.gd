#extends KinematicBody2D
extends Bit

var bit_string = "0"
var frame_to_use

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bit_particles = load("res://Assets/Art/Units/unit_bit_buildable_particle_base.png")
	bit_dict = {
		"1": 0, 
		"0": 1,
		"00": 2,
		"01": 3, 
		"10": 4, 
		"11": 5, 
		"000": 6,
		"001": 7,
		"100": 8,
		"010": 9,
		"011": 10,
		"110": 11,
		"101": 12,
		"111": 13,
		"0000": 14,
		"0001": 15,
		"0010": 16,
		"0011": 17,
		"0100": 18,
		"0101": 19,
		"0110": 20,
		"0111": 21,
		"1000": 22,
		"1001": 23,
		"1010": 24,
		"1011": 25,
		"1100": 26,
		"1101": 27,
		"1110": 28,
		"1111": 29
	}
	
	frame_to_use = bit_dict[bit_string]
	sprite.frame = frame_to_use
