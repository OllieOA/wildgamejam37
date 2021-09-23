extends NinePatchRect

onready var blip_player = $Blip_voice
onready var arbyg_player = $Argyb_voice

var arby_happy = preload("res://Assets/Art/Characters/ArbyG_Happy.png")
var arby_sad = preload("res://Assets/Art/Characters/ArbyG_Sad.png")
var arby_confused = preload("res://Assets/Art/Characters/ArbyG_Confused.png")
var arby_neutral = preload("res://Assets/Art/Characters/ArbyG_Neutral.png")

var arby_portraits = {
	"Happy": arby_happy,
	"Sad": arby_sad,
	"Confused": arby_confused,
	"Neutral": arby_neutral
}

var blip_happy = preload("res://Assets/Art/Characters/BLIP_Happy.png")
var blip_sad = preload("res://Assets/Art/Characters/BLIP_Sad.png")
var blip_confused = preload("res://Assets/Art/Characters/BLIP_Confused.png")
var blip_neutral = preload("res://Assets/Art/Characters/BLIP_Neutral.png")

var blip_portraits = {
	"Happy": blip_happy,
	"Sad": blip_sad,
	"Confused": blip_confused,
	"Neutral": blip_neutral
}

var portraits = {
	"BLIP": blip_portraits,
	"ArbyG": arby_portraits
}

var dialogue_path = ""
var text_speed = 0.02

onready var timer = $Timer
onready var dialogue_name = $Name
onready var dialogue_text = $Text
onready var indicator = $Indicator
onready var portrait = $Portrait

var dialogue
signal dialogue_complete_bool
var phrase_number = 0
var finished = false

func _ready() -> void:
	timer.wait_time = text_speed
	dialogue = get_dialogue()
	assert(dialogue, "Dialogue file missing after reading it!")
	
	next_phrase()

func _process(delta: float) -> void:
	indicator.visible = finished
	if Input.is_action_just_pressed("accept_dialogue"):
		if finished:
			next_phrase()
		else:
			dialogue_text.visible_characters = len(dialogue_text.text)

func get_dialogue() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogue_path), "Dialogue file missing.. sorry!")
	
	f.open(dialogue_path, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []


func next_phrase():
	if phrase_number >= len(dialogue):
		world_parameters.current_dialogue_completed = true
		queue_free()
		return
		
	finished = false
	var current_speaker = dialogue[phrase_number]["Name"]
	var audio_start_point = rand_range(0.0, 4.0)
	if current_speaker == "ArbyG":
		arbyg_player.play(audio_start_point)
	elif current_speaker == "BLIP":
		blip_player.play(audio_start_point)
	
	dialogue_name.bbcode_text = " " + dialogue[phrase_number]["Name"]
	var dialogue_text_to_show = " " + dialogue[phrase_number]["Text"]
	dialogue_text.bbcode_text = dialogue_text_to_show
	
	dialogue_text.visible_characters = 0
	
	# Figure out portrait to use
	var f = File.new()
	
	var char_name = dialogue[phrase_number]["Name"]
	var char_emotion = dialogue[phrase_number]["Emotion"]
	var new_texture = portraits[char_name][char_emotion]

	portrait.texture = new_texture
	
	while dialogue_text.visible_characters < len(dialogue_text.text):
		dialogue_text.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
	
	arbyg_player.stop()
	blip_player.stop()
	
	finished = true
	phrase_number += 1
	return
		
		
		
		
