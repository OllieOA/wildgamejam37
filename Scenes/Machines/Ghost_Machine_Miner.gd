extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var build_check_area = $Build_Check_Area
var build_offset
var buildable
var clear_of_areas
var clear_of_bodies
onready var belt_check_area = $BeltCheckArea

var rotation_offset

func _ready() -> void:
	modulate.a8 = int(255 * 0.6)
	buildable = true
	clear_of_areas = true
	clear_of_bodies = true
	build_offset = Vector2(-8, -8)
	rotation_offset = {
		0: [0, 0],
		90: [16, 0],
		180: [16, 16],
		270: [0, 16]
	}

var loop_counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loop_counter += 1
	if loop_counter % 200 == 0:
		print("In the build checker:")
		for area in build_check_area.get_overlapping_areas():
			print(area.get_name())
		print("In the belt checker:")
		for area in belt_check_area.get_overlapping_areas():
			print(area.get_name())
	
	if clear_of_areas:
		# Confirm
		if len(build_check_area.get_overlapping_areas()) == 0:
			buildable = true
		else:
			buildable = false
	elif not clear_of_areas and len(belt_check_area.get_overlapping_areas()) > 1:
		
		var belts_only = true
		for area in build_check_area.get_overlapping_areas():
			if not "Conveyor" in area.get_name():
				belts_only = false
		
		if "Conveyor" in belt_check_area.get_overlapping_areas()[0].get_name() and belts_only:
			buildable = true
		else:
			buildable = false
	elif not clear_of_areas:
		buildable = false

# AREAS
func _on_Build_Check_Area_area_entered(area: Area2D) -> void:
	clear_of_areas = false
func _on_Build_Check_Area_area_exited(area: Area2D) -> void:
	# Check if clear
	if len(build_check_area.get_overlapping_areas()) == 0:
		clear_of_areas = true
	else:
		clear_of_areas = false
