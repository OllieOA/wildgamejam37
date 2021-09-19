extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var build_check_area = $Build_Check_Area
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
	buildable = true	
	# Decide if item is buildable
	for body in build_check_area.get_overlapping_bodies():
		if "Machine" in body.get_name() or "Arby" in body.get_name():
			buildable = false
	
	for area in build_check_area.get_overlapping_areas():
		if "Machine" in area.get_name():
			buildable = false
