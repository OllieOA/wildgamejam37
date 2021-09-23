extends StaticBody2D

var blip_in_range
onready var prompt_player = $Prompt
onready var dialogue_handler = preload("res://UI/DialogueSystem.tscn")
export var curr_level = 0

var first_dialogue_finished
var one_shot_dialogue  # Get the dialogue file for the oneshot
var help_dialogues
var completed_dialogue
var help_cycle = 0
var dialogue_signal_received = false
var dialogue_current_playing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	first_dialogue_finished = false
	dialogue_current_playing = false
	blip_in_range = false
	$AnimationPlayer.play("Idle")
	print("PREPARING DIALOGUE FOR LEVEL ", curr_level)
	one_shot_dialogue = "res://Assets/Dialogue/Level" + str(curr_level) + "/dialogue_" + str(curr_level) + "_one_shot.json"
	help_dialogues = [
		"res://Assets/Dialogue/Level" + str(curr_level) + "/dialogue_" + str(curr_level) + "_help1.json",
		"res://Assets/Dialogue/Level" + str(curr_level) + "/dialogue_" + str(curr_level) + "_help2.json",
		"res://Assets/Dialogue/Level" + str(curr_level) + "/dialogue_" + str(curr_level) + "_help3.json"
		]

func _process(delta: float) -> void:
	if blip_in_range:
		if not prompt_player.visible:
			prompt_player.show()
		if Input.is_action_just_pressed("activate"):
			# IF FIRST TIME IN LEVEL
			if not first_dialogue_finished and not dialogue_current_playing:
				dialogue_current_playing = true
				play_dialogue(one_shot_dialogue)
				# dialogue finished
				first_dialogue_finished = true
			elif not dialogue_current_playing:
				# Play a help
				dialogue_current_playing = true
				help_cycle += 1
				if help_cycle == 3:
					help_cycle = 0
				play_dialogue(help_dialogues[help_cycle])

	else:
		if prompt_player.visible:
			prompt_player.hide()

func play_dialogue(dialogue_path_to_play):
	get_tree().paused = true
	# Spawn dialogue system
	world_parameters.current_dialogue_completed = false
	var dialogue_instance = dialogue_handler.instance()
	dialogue_instance.get_node("DialogueBox").dialogue_path = dialogue_path_to_play
	get_tree().get_current_scene().get_node("CanvasLayer/DialogueRenderer").add_child(dialogue_instance)
	
	while not world_parameters.current_dialogue_completed:
		yield(get_tree().create_timer(0.1), "timeout")
	get_tree().paused = false

	if "one_shot" in dialogue_path_to_play:
		first_dialogue_finished = true
		
	dialogue_current_playing = false

func _on_Dialogue_Checker_body_entered(body: Node) -> void:
	blip_in_range = true


func _on_Dialogue_Checker_body_exited(body: Node) -> void:
	blip_in_range = false
