extends Node2D

var bit_string = "1"
var bit_string_base
var frame_to_use

onready var activity_checker = $ActivityChecker
onready var sprite = $Sprite

var bit_mineable_dict = {
	"0110": 0,
	"1": 1,
	"0": 2,
	"10": 3
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bit_string_base = bit_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bit_string_base != bit_string:
		frame_to_use = bit_mineable_dict[bit_string]
		sprite.frame = frame_to_use
