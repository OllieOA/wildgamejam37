extends StaticBody2D

onready var animator = $AnimationPlayer
onready var ambient_audio_player = $Ambient
onready var win_player = $WinPlayer
onready var no_player = $NoPlayer
onready var yes_player = $YesPlayer

onready var input_1_detector = $Input1/Input_Detector
onready var input_2_detector = $Input2/Input_Detector

# Vars for eating stuff
export var desired_bit_strings = ["0"]
var bits_delivered: Dictionary = {}
var input_1_inv
var input_2_inv
var completed = false
var enable_finish

# Custom rotation handling
var output_rotation_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	enable_finish = false
	output_rotation_offset = {
		0: [0, 0],
		90: [-8, 0],
		180: [-8, -8],
		270: [0, -8]
	}
	
	bits_delivered = {}
	for bit in desired_bit_strings:
		bits_delivered[bit] = false

	input_1_inv = null
	input_2_inv = null
	completed = false
	
	var make_timer = Timer.new()
	add_child(make_timer)
	make_timer.set_wait_time(world_parameters.flipper_time)
	make_timer.connect("timeout", self, "_on_make_timeout")  # Check if there is a filled inventory
	make_timer.start()
	
	var input_1_check_timer = Timer.new()
	add_child(input_1_check_timer)
	input_1_check_timer.set_wait_time(2 / 20)
	input_1_check_timer.connect("timeout", self, "_on_input_1_check_timeout")
	input_1_check_timer.start()
	
	var input_2_check_timer = Timer.new()
	add_child(input_2_check_timer)
	input_2_check_timer.set_wait_time(world_parameters.flipper_time / 20)
	input_2_check_timer.connect("timeout", self, "_on_input_2_check_timeout")
	input_2_check_timer.start()
	
	animator.assigned_animation = "Idle"

func _process(delta):
	
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
				check_win(input_1_inv)
				input_1_inv = null


func check_win(input_inv):
	if input_inv in desired_bit_strings:
		if not bits_delivered[input_inv]:
			# Count the falses
			var false_count = 0
			for value in bits_delivered.values():
				if not value:
					false_count += 1
				if false_count == 1:
					bits_delivered[input_inv] = true
					# Last one
					completed = true
					ambient_audio_player.play()
					win_player.play()
				else:
					bits_delivered[input_inv] = true
					# Not last one
					ambient_audio_player.stop()
					yes_player.play()
					ambient_audio_player.play()
	else:
		# Wrong bit
		ambient_audio_player.stop()
		no_player.play()
		ambient_audio_player.play()
	input_inv = null
