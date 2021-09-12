""" Game management

	This script will manage the timing aspect of the game and provide a tick
	for machines/belts etc. to use
"""

extends Node2D
var total_ticks = 0
var tick_time = 0.5

# Get children for debugging
onready var blip = get_node("BLIP")
onready var bit = get_node("Bit_Minable")

func _ready():
	# Establish a tick timer
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(tick_time)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()


func _on_Timer_timeout():
	#print("DEBUG: BLIP VELOCITY is " + str(blip.display_velocity))
	print("DEBUG: BIT POS is " + str(bit.curr_position))
	pass
