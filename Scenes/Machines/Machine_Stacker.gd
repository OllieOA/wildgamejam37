extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")
	
	# TEMP CODE
	var timer = Timer.new()
	timer.set_wait_time(4)
	self.add_child(timer)
	timer.start()
	
	yield(timer, "timeout")
	$AnimationPlayer.play("Running")
	
	timer.queue_free()
