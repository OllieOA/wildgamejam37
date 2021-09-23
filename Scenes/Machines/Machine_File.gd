extends StaticBody2D

onready var animator = $AnimationPlayer
onready var ambient_audio_player = $Ambient
onready var win_player = $WinPlayer
onready var no_player = $NoPlayer
onready var yes_player = $YesPlayer
onready var prompt_player = $Prompt

onready var input_1_detector = $Input1/Input_Detector
onready var input_2_detector = $Input2/Input_Detector

# Vars for eating stuff
export var desired_bit_strings = []
export var desired_quantities = {}
var bits_delivered: Dictionary = {}
var quantity_delivered: Dictionary = {}
var input_1_inv
var input_2_inv
var completed = false  # CHANGE BACK
var enable_finish
var blip_in_range
var base_input_check_time
var input_1_check_timer
var input_2_check_timer

# Custom rotation handling
var output_rotation_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	blip_in_range = false
	enable_finish = false
	prompt_player.hide()
	output_rotation_offset = {
		0: [0, 0],
		90: [-8, 0],
		180: [-8, -8],
		270: [0, -8]
	}
	
	bits_delivered = {}
	for bit in desired_bit_strings:
		bits_delivered[bit] = false
		
	var current_delivered = {}
	for bit in desired_bit_strings:
		quantity_delivered[bit] = 0

	input_1_inv = null
	input_2_inv = null
	completed = false
	
	base_input_check_time = world_parameters.file_time
	
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
	
	animator.assigned_animation = "Idle"

func _process(delta):
	# Update for speed mode
	if world_parameters.speed_mode_active:
		var new_input_wait_time = base_input_check_time / world_parameters.speed_mode_factor
		if input_1_check_timer.get_wait_time()-0.001 > new_input_wait_time:
			input_1_check_timer.set_wait_time(new_input_wait_time)
		if input_2_check_timer.get_wait_time()-0.001 > new_input_wait_time:
			input_2_check_timer.set_wait_time(new_input_wait_time)
	else:
		if input_1_check_timer.get_wait_time()+0.001 < base_input_check_time:
			input_1_check_timer.set_wait_time(base_input_check_time)
		if input_2_check_timer.get_wait_time()+0.001 < base_input_check_time:
			input_2_check_timer.set_wait_time(base_input_check_time)
	
	if blip_in_range and completed:
		if not prompt_player.visible:
			prompt_player.show()
		if Input.is_action_just_pressed("activate"):
			unlocker.level_complete_trigger = true
	else:
		if prompt_player.visible:
			prompt_player.hide()
	
	
	if not completed:
		if not animator.is_playing():
			animator.play("Idle")
		if not ambient_audio_player.playing:
			ambient_audio_player.play()
	else:
		animator.assigned_animation = "Complete"
		yield(get_tree().create_timer(2.0), "timeout")
		ambient_audio_player.stop()
		

func _on_input_1_check_timeout():
	if input_1_inv == null:
		var bodies = input_1_detector.get_overlapping_bodies()
		for body in bodies:
			if "Bit" in body.get_name():
				input_1_inv = body.bit_string
				body.mark_for_absorption = true
				# Check if this bit was desired
				check_win(input_1_inv)
				input_1_inv = null


func _on_input_2_check_timeout():
	if input_2_inv == null:
		var bodies = input_2_detector.get_overlapping_bodies()
		for body in bodies:
			if "Bit" in body.get_name():
				input_2_inv = body.bit_string
				body.mark_for_absorption = true
				# Check if this bit was desired
				check_win(input_2_inv)
				input_2_inv = null


func check_win(input_inv):
	if input_inv in desired_bit_strings:
		# Add to qty 
		quantity_delivered[input_inv] += 1
		if quantity_delivered[input_inv] >= desired_quantities[input_inv]:
			bits_delivered[input_inv] = true
		
		# Check if all have been made true
		var win_check_val = true
		for value in bits_delivered.values():
			win_check_val = win_check_val and value  # Check if all true
		
		if win_check_val and not completed:
			# Play completed
			completed = true
			ambient_audio_player.stop()
			win_player.play()
		else:
			# Not last one
			ambient_audio_player.stop()
			yes_player.play()
			if not completed:
				ambient_audio_player.play()
	else:
		# Wrong bit
		if not completed:  # Don't even stress about it mate
			ambient_audio_player.stop()
			no_player.play()
			ambient_audio_player.play()
		else:
			no_player.play()
	input_inv = null


func _on_BLIP_Checker_body_entered(body: Node) -> void:
	blip_in_range = true


func _on_BLIP_Checker_body_exited(body: Node) -> void:
	blip_in_range = false
