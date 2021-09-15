extends StaticBody2D

export var bit_string_to_mine = "10"
export (PackedScene) var Minable_Unit

onready var animator = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D

var enabled
var tick_time = 2
onready var mine_timer = $Mine_Timer
onready var output1_location = $Output1

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled = false
	animator.play("Idle")
	
	# Set timer to emulate gameplay
	var timer = Timer.new()
	timer.set_wait_time(4)
	self.add_child(timer)
	timer.start()

	yield(timer, "timeout")
	enabled = true
	
	timer.queue_free()
	
	# Create a looping timer for mining
	mine_timer.set_wait_time(tick_time)
	mine_timer.connect("timeout", self, "_on_mine_timeout")
	mine_timer.start()

#	# TEMP CODE
#	var timer = Timer.new()
#	timer.set_wait_time(4)
#	self.add_child(timer)
#	timer.start()
#
#	yield(timer, "timeout")
#	$AnimationPlayer.play("Running")
#	$AudioStreamPlayer2D.play()
#
#	timer.queue_free()
#
#	var timer2 = Timer.new()
#	timer2.set_wait_time(20)
#	self.add_child(timer2)
#	timer2.start()
#
#	yield(timer2, "timeout")
#	self.queue_free()

func _process(delta):
	if enabled:
		if "Idle" in animator.current_animation:
			animator.play("Running")
		if not audio_player.playing:
			audio_player.play()
		if mine_timer.paused:
			self.mine_timer.paused = false
			
	if not enabled:
		if "Running" in animator.current_animation:
			animator.play("Idle")
		if audio_player.playing:
			audio_player.stop()
		if not mine_timer.paused:
			mine_timer.paused = true
			
	
	# Fake turnoff
	var timer2 = Timer.new()
	timer2.set_wait_time(20)
	self.add_child(timer2)
	timer2.start()
	
	yield(timer2, "timeout")
	enabled = false
	timer2.queue_free()


func _on_mine_timeout():
	var minable_unit = Minable_Unit.instance()
	minable_unit.bit_string = bit_string_to_mine
	minable_unit.global_position = output1_location.global_position
	# TODO: Add rotation logic to spawning (i.e. add offsets to the output location)
	# Instance in main tree
	get_tree().get_current_scene().get_node("Units").add_child(minable_unit)

	
	
	