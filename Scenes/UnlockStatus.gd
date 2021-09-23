extends Node

var bit_conveyor = false
var bit_converyor_level = 1
var splitter = false
var splitter_level = 5
var miner = false
var miner_level = 1
var bit_stacker = false
var bit_stacker_level = 4
var flipper = false
var flipper_level = 3
var or_builder = false
var or_builder_level = 6
var byte_conveyor = false
var byte_conveyor_level = 8
var byte_stacker = false
var byte_stacker_level = 8

var speed_mode = false
var speed_mode_level = 4
var max_level_reached = 0


var current_level

var level_complete_trigger = false
var destroy_blip = false

func _ready() -> void:
	current_level = 0
	var unlock_timer = Timer.new()
	add_child(unlock_timer)
	unlock_timer.set_wait_time(0.1)
	unlock_timer.connect("timeout", self, "_on_unlock_timeout")
	unlock_timer.start()

func _process(delta: float) -> void:
	if level_complete_trigger and not destroy_blip:
		level_complete_trigger = false
		destroy_blip = true
		yield(get_tree().create_timer(2.0), "timeout")
		# Load next scene
		var next_level = get_tree().get_current_scene().next_level
		destroy_blip = false
		SceneTransition.goto_scene(next_level)
		# IF LAST SCENE THEN POPUP
		
	if current_level > max_level_reached:
		max_level_reached = current_level
		
func _on_unlock_timeout():
	# Check for unlocks
	if current_level >= bit_converyor_level and not bit_conveyor:
		bit_conveyor = true
	if current_level >= splitter_level and not splitter:
		splitter = true
	if current_level >= miner_level and not miner:
		miner = true
	if current_level >= flipper_level and not flipper:
		flipper = true
	if current_level >= bit_stacker_level and not bit_stacker:
		bit_stacker = true
	if current_level >= or_builder_level and not or_builder:
		or_builder = true
	# CHECK FOR BYTES
		
	if current_level >= speed_mode_level and not speed_mode:
		speed_mode = true
