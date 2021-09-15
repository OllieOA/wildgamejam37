extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
var build_offset
var buildable

var loop_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.modulate.a8 = int(255 * 0.6)
	buildable = true
	build_offset = Vector2(-8, -8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loop_counter += 1
	if loop_counter > 100:
		loop_counter = 0
		
	if global_position.x < 0:
		buildable = false
	else:
		buildable = true
