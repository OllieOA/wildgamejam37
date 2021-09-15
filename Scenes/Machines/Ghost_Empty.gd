extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
var build_offset
var buildable

func _ready() -> void:
	sprite.hide()
	sprite.modulate.a8 = int(255 * 0.6)
	buildable = false
	build_offset = Vector2(-8, -8)
