extends Node

var conveyor_speed = 0.2
var tick_time = 0.4

func _ready():
	# Establish a tick timer for belts
	var belt_timer = Timer.new()
	add_child(belt_timer)
	belt_timer.set_wait_time(tick_time)
	belt_timer.connect("timeout", self, "_on_belt_sync_timeout")
	belt_timer.start()
	
	var miner_timer = Timer.new()
	add_child(miner_timer)
	miner_timer.set_wait_time(tick_time * 5)
	miner_timer.connect("timeout", self, "_on_miner_sync_timeout")
	miner_timer.start()


func _on_belt_sync_timeout():
	get_tree().call_group("belt_animations", "seek", 0.0)  # Sync animation

func _on_miner_sync_timeout():
	get_tree().call_group("miners", "mine_unit")
