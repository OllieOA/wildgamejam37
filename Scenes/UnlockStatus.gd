extends Node

var bit_conveyor = true
var splitter = true
var miner = true
var bit_stacker = false
var flipper = true
var or_builder = false
var byte_conveyor = false
var byte_stacker = false

var level_complete_trigger = false
var destroy_blip = false

func _process(delta: float) -> void:
	if level_complete_trigger and not destroy_blip:
		destroy_blip = true
		yield(get_tree().create_timer(2.0), "timeout")
		# Load next scene
