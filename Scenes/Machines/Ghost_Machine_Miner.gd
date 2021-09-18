extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var build_check_area = $Build_Check_Area
var build_offset
var buildable
var clear_of_areas
var clear_of_bodies
var on_cache
var clear_from_machines
onready var belt_check_area = $BeltCheckArea
var miner_bit_string

var rotation_offset

func _ready() -> void:
	miner_bit_string = null
	on_cache = false
	clear_from_machines = false
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

	# First gate, check that it is on a bit_cache
	var build_overlapping_areas = build_check_area.get_overlapping_areas()
	var belt_overlapping_areas = belt_check_area.get_overlapping_areas()
	
	var no_machines = true
	for area in build_overlapping_areas:
		if "Machine" in area.get_name():
			no_machines = false
	for area in belt_overlapping_areas:
		if "Machine" in area.get_name():
			no_machines = false
	for body in build_check_area.get_overlapping_bodies():
		if "Machine" in body.get_name():
			no_machines = false
	
	# If there are 4 minable bit areas (and NONE in belt_overlapping), buildable
	var bit_count = 0
	for area in build_overlapping_areas:
		if "Bit" in area.get_name():
			bit_count += 1
	if bit_count == 5:  # Covering 5
		on_cache = true
	elif bit_count == 4:  # Ensure this bit isn't in the belt area
		var minable_in_belt = false
		for area in belt_overlapping_areas:
			if "Bit" in area.get_name():
				minable_in_belt = true
		if not minable_in_belt:
			on_cache = true
		else:
			on_cache = false
	else: 
		on_cache = false

	# Then, use machine logic
	# Figure out what is colliding
	var machines_in_build_area = 0
	for area in build_overlapping_areas:
		if "Machine" in area.get_name():
			machines_in_build_area += 1
	for body in build_check_area.get_overlapping_bodies():
		if "Machine" in body.get_name():
			machines_in_build_area += 1

	var len_1_in_build = machines_in_build_area == 1
	
	var conveyor_in_build = false
	for area in build_overlapping_areas:
		if "Conveyor" in area.get_name():
			conveyor_in_build = true
	
	var machines_in_belt_area = 0
	for area in belt_overlapping_areas:
		if "Machine" in area.get_name():
			machines_in_belt_area += 1
			
	var len_1_in_belt = machines_in_belt_area == 1
	
	var conveyor_in_belt = false
	for area in belt_overlapping_areas:
		if "Conveyor" in area.get_name():
			conveyor_in_belt = true
	
	# I am bad at logic
	# Check that, even if the areas are not clear, it's just one conveyor belt in the belt area
	if (len_1_in_belt and len_1_in_build and conveyor_in_belt and conveyor_in_build) or no_machines:
		clear_from_machines = true
	else:
		clear_from_machines = false
	
	# Finally confirm can be built and provide the bit string
	if on_cache and clear_from_machines:
		buildable = true
		for area in build_check_area.get_overlapping_areas():
			if "Bit" in area.get_name():
				miner_bit_string = area.get_parent().give_bit_string()
	else:
		buildable = false

# BODIES
func _on_Build_Check_Area_body_entered(body) -> void:
	clear_from_machines = true
	if "Machine" in body.get_name():
		clear_from_machines = false
func _on_Build_Check_Area_body_exited(body) -> void:
	# Check if clear
	clear_from_machines = true
	for each_body in build_check_area.get_overlapping_bodies():
		if "Machine" in each_body.get_name():
			clear_from_machines = false

# AREAS
func _on_Build_Check_Area_area_entered(area: Area2D) -> void:
	clear_from_machines = true
	if "Machine" in area.get_name():
		clear_from_machines = false
func _on_Build_Check_Area_area_exited(area: Area2D) -> void:
	# Check if clear
	clear_from_machines = true
	for each_area in build_check_area.get_overlapping_areas():
		if "Machine" in each_area.get_name():
			clear_from_machines = false
