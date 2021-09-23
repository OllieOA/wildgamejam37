extends StaticBody2D

onready var Buildable_Unit = preload("res://Scenes/Moving_Entities/Bit_Buildable.tscn")

onready var animator = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D
onready var bad_construction = $bad_construction
onready var blockage_detector = $Output1/BlockageDetector

var enabled
onready var output1_location = $Output1
onready var input1_location = $Input1
onready var input_1_detector = $Input1/Input_Detector
onready var input2_location = $Input2
onready var input_2_detector = $Input2/Input_Detector

# Vars for making stuff
var spawned_instance_id
var successful_mine
var blocked
var produced
var cleared_last_produced
var triggered_to_produce
signal successfully_mined
var bit_string
var input_1_inv
var input_2_inv

# Custom rotation handling
var output_rotation_offset

# vars for speedmode
var base_make_time
var base_input_check_time
var make_timer
var input_1_check_timer
var input_2_check_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	spawned_instance_id = null
	blocked = false
	cleared_last_produced = true
	output_rotation_offset = {
		0: [0, 0],
		90: [-8, 0],
		180: [-8, -8],
		270: [0, -8]
	}
	
	base_make_time = world_parameters.bit_stacker_time * world_parameters.machine_speed_base
	base_input_check_time = base_make_time / 20.0

	enabled = false
	input_1_inv = null
	
	make_timer = Timer.new()
	add_child(make_timer)
	make_timer.one_shot = true
	make_timer.set_wait_time(base_make_time)
	make_timer.connect("timeout", self, "_on_make_timeout")  # Check if there is a filled inventory
	# make_timer.start()
	
	input_1_check_timer = Timer.new()
	add_child(input_1_check_timer)
	input_1_check_timer.set_wait_time(base_input_check_time)
	input_1_check_timer.connect("timeout", self, "_on_input_1_check_timeout")
	input_1_check_timer.start()
	
	input_2_check_timer = Timer.new()
	add_child(input_2_check_timer)
	input_2_check_timer.set_wait_time(base_input_check_time)
	input_2_check_timer.connect("timeout", self, "_on_input_2_check_timeout")
	input_2_check_timer.start()

func _process(delta):
	# Update for speed mode
	if world_parameters.speed_mode_active:
		var new_make_wait_time = base_make_time / world_parameters.speed_mode_factor
		
		if make_timer.get_wait_time()-0.01 > new_make_wait_time:  # FLOATING POINTS BRO
			make_timer.set_wait_time(new_make_wait_time)
		if input_1_check_timer.get_wait_time()-0.001 > new_make_wait_time / 20.0:
			input_1_check_timer.set_wait_time(new_make_wait_time / 20.0)
	else:
		if make_timer.get_wait_time()+0.01 < base_make_time:
			make_timer.set_wait_time(base_make_time)
		if input_1_check_timer.get_wait_time()+0.001 < base_input_check_time:
			input_1_check_timer.set_wait_time(base_input_check_time)
	
	if not animator.is_playing():
		animator.play("Running")
	
	if enabled:
		if "Idle" in animator.current_animation:
			animator.play("Running")
		if not audio_player.playing:
			audio_player.play()
			
	if not enabled:
		
		# Check if can be enabled
		if cleared_last_produced and not blocked:
			enabled = true
		else:
			if "Running" in animator.current_animation:
				animator.play("Idle")
			if audio_player.playing:
				audio_player.stop()

func _on_input_1_check_timeout():
	if input_1_inv == null:
		var bodies = input_1_detector.get_overlapping_bodies()
		for body in bodies:
			if "Bit" in body.get_name():
				input_1_inv = body.bit_string
				body.mark_for_absorption = true
				if input_2_inv != null:
					# Check if invalid
					var bit_valid = check_output_bit(input_1_inv, input_2_inv)
					if not bit_valid:
						bit_not_valid()
					else:
						make_timer.start()


func _on_input_2_check_timeout():
	if input_2_inv == null:
		var bodies = input_2_detector.get_overlapping_bodies()
		for body in bodies:
			if "Bit" in body.get_name():
				input_2_inv = body.bit_string
				body.mark_for_absorption = true
				if input_1_inv != null:
					# Check if invalid
					var bit_valid = check_output_bit(input_1_inv, input_2_inv)
					if not bit_valid:
						bit_not_valid()
					else:
						make_timer.start()


func _on_make_timeout():
	# if there is something in the inventory, try and make it
	if input_1_inv != null and cleared_last_produced:
		# Conduct machine's operation
		var output_bit_string = operate_machine(input_1_inv, input_2_inv)
		produce_bit(output_bit_string)
		input_1_inv = null
		input_2_inv = null


func _on_BlockageDetector_body_exited(body: Node) -> void:
	# Check if there are any bodies inside
	if len(blockage_detector.get_overlapping_bodies()) > 0:
		# Area is blocked
		blocked = true
	else:
		blocked = false
	
	if body.get_instance_id() == spawned_instance_id:
		# If the body that exited was the one just produced, prep to produce another
		cleared_last_produced = true


func produce_bit(bit_string):
	var buildable_unit_instance = Buildable_Unit.instance()
	#var buildable_unit_instance = Minable_Unit.instance()
	
	buildable_unit_instance.bit_string = bit_string
	buildable_unit_instance.global_position = output1_location.global_position + Vector2(-4, -4)
	spawned_instance_id = buildable_unit_instance.get_instance_id()
	
	get_tree().get_current_scene().get_node("Units").add_child(buildable_unit_instance)
	cleared_last_produced = false  # Latch down


func operate_machine(first_bit, second_bit):
	# This adds the first to second
	var output_string = first_bit + second_bit
	return output_string


func check_output_bit(first_bit, second_bit) -> bool:
	if len(first_bit) + len(second_bit) > 4:
		return false
	return true


func bit_not_valid():
	input_1_inv = null
	input_2_inv = null
	bad_construction.play()
