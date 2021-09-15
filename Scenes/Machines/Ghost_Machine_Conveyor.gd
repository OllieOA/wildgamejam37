extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
var build_offset
var buildable

var rotation_offset

func _ready() -> void:
	sprite.modulate.a8 = int(255 * 0.6)
	buildable = true
	build_offset = Vector2.ZERO
	rotation_offset = {
		0: [0, 0],
		90: [8, 0],
		180: [8, 8],
		270: [0, 8]
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Decide if item is buildable
	if global_position.x < 0:
		buildable = false
	else:
		buildable = true
