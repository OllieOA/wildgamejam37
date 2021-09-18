extends StaticBody2D

var bit_string = "0"
onready var Minable_Unit = preload("res://Scenes/Moving_Entities/Bit_Minable.tscn")

onready var animator = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D
onready var blockage_detector = $Output1/BlockageDetector

var enabled
var tick_time = 2
onready var mine_timer = $Mine_Timer
onready var output1_location = $Output1

# Vars for mining stuff
var spawned_instance_id
var successful_mine
var blocked
var produced
var cleared_last_produced
var ready_to_produce
var triggered_to_produce
signal successfully_mined

# Custom rotation handling
var output_rotation_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.add_to_group("miners", true)
	
	# Get bit string from caches	
	spawned_instance_id = null
	blocked = false
	ready_to_produce = true
	cleared_last_produced = true
	output_rotation_offset = {
		0: [0, 0],
		90: [-8, 0],
		180: [-8, -8],
		270: [0, -8]
	}
	
	enabled = true

func _process(delta):
	
	if not animator.is_playing():
		animator.play("Running")
	
	if enabled:
		if "Idle" in animator.current_animation:
			animator.play("Running")
		if not audio_player.playing:
			audio_player.play()
		if mine_timer.paused:
			self.mine_timer.paused = false
			
	if not enabled:
		
		# Check if can be enabled
		if cleared_last_produced and not blocked:
			enabled = true
		else:
			if "Running" in animator.current_animation:
				animator.play("Idle")
			if audio_player.playing:
				audio_player.stop()


func _on_mine_timeout():
	var minable_unit = Minable_Unit.instance()
	minable_unit.bit_string = bit_string
	minable_unit.global_position = output1_location.global_position + Vector2(-4, -4)

	# Instance in main tree
	get_tree().get_current_scene().get_node("Units").add_child(minable_unit)


func mine_unit():
	triggered_to_produce = true
	# If not blocked AND if the current mined block has exited the area...
	if cleared_last_produced and not blocked:
		produce_bit()
		triggered_to_produce = false
	else:
		enabled = false

func _on_BlockageDetector_body_exited(body: Node) -> void:
	# Check if there are any bodies inside
	if len(blockage_detector.get_overlapping_bodies()) > 0:
		print(blockage_detector.get_overlapping_bodies())
		# Area is blocked
		blocked = true
	else:
		blocked = false
	
	if body.get_instance_id() == spawned_instance_id:
		# If the body that exited was the one just produced, prep to produce another
		emit_signal("successfully_mined")
		cleared_last_produced = true
		
	if triggered_to_produce and cleared_last_produced and not blocked:
		produce_bit()
		triggered_to_produce = false


func produce_bit():
	var minable_unit_instance = Minable_Unit.instance()
	minable_unit_instance.bit_string = bit_string
	minable_unit_instance.global_position = output1_location.global_position + Vector2(-4, -4)
	spawned_instance_id = minable_unit_instance.get_instance_id()
	
	get_tree().get_current_scene().get_node("Units").add_child(minable_unit_instance)
	cleared_last_produced = false  # Latch down
	ready_to_produce = false
