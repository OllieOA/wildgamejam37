extends Node

var conveyor_speed_base = 0.2
var conveyor_speed
var machine_speed_base = 0.2
var machine_speed
var speed_mode_factor
var speed_mode_active
var speed_mode_available
var miner_timer

var base_bit_speed = 100
var snap_size = 8
var tick_time = 0.4

# Machine timer factors - multipliers to machine_speed_base
var flipper_time = 30.0
var miner_time = 10.0
var bit_stacker_time = 20.0
var file_time = 0.5
var base_miner_time
var curr_level = 0
var helps_per_level = 3

# Dialogue
var current_dialogue_completed

func _ready():
	current_dialogue_completed = true
	
	# Establish a tick timer for belts
	var belt_timer = Timer.new()
	add_child(belt_timer)
	belt_timer.set_wait_time(tick_time)
	belt_timer.connect("timeout", self, "_on_belt_sync_timeout")
	belt_timer.start()
	
	miner_timer = Timer.new()
	add_child(miner_timer)
	miner_timer.set_wait_time(tick_time * 5)
	miner_timer.connect("timeout", self, "_on_miner_sync_timeout")
	miner_timer.start()
	
	conveyor_speed = conveyor_speed_base
	machine_speed = machine_speed_base
	
	# Special case for miner
	base_miner_time = miner_time * machine_speed_base
	
	speed_mode_active = false
	speed_mode_available = true
	speed_mode_factor = 3.0

func _process(delta: float) -> void:
	if world_parameters.speed_mode_active:
		var new_make_wait_time = base_miner_time / speed_mode_factor
		if miner_timer.get_wait_time()-0.01 > new_make_wait_time:  # FLOATING POINTS BRO
			miner_timer.set_wait_time(new_make_wait_time)
	else:
		if miner_timer.get_wait_time()+0.01 < base_miner_time:
			miner_timer.set_wait_time(base_miner_time)


func _on_belt_sync_timeout():
	get_tree().call_group("belt_animations", "seek", 0.0)  # Sync animation

func _on_miner_sync_timeout():
	get_tree().call_group("miners", "mine_unit")
	
func _on_speed_mode_timeout():
	speed_mode_active = false
	
	# Reset speeds
	conveyor_speed = conveyor_speed_base
	var speed_mode_restart_timer = Timer.new()
	add_child(speed_mode_restart_timer)
	speed_mode_restart_timer.set_wait_time(5)
	speed_mode_restart_timer.connect("timeout", self, "_on_speed_mode_restart")
	speed_mode_restart_timer.start()
	
func _on_speed_mode_restart():
	speed_mode_available = true
	

func _input(event):
	if event.is_action_released("speed_mode") and speed_mode_available and unlocker.speed_mode:
		speed_mode_active = true
		speed_mode_available = false
		
		# Update processing speed globals
		conveyor_speed = conveyor_speed_base * speed_mode_factor
		machine_speed = machine_speed_base * speed_mode_factor
		
		# Set timer
		var speed_mode_timer = Timer.new()
		add_child(speed_mode_timer)
		speed_mode_timer.set_wait_time(10)
		speed_mode_timer.connect("timeout", self, "_on_speed_mode_timeout")
		speed_mode_timer.start()
		
		# Update miners
		
