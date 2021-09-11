""" Game management

	This script will manage the timing aspect of the game and provide a tick
	for machines/belts etc. to use
"""

extends Node2D
var total_ticks = 0
var tick_time = 0.01

func _ready():
	# Establish a tick timer
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(tick_time)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()


func _on_Timer_timeout():
	pass
