extends Sprite

var snap_size = 8
var sprite_to_build = -1
var ghost_loaded = false
var extra_offset
var alpha = 0.8
var buildable_colour = Vector3(84, 255, 20)
var non_buildable_colour = Vector3(255, 28, 28)
var colour_mask = Vector3.ZERO

# Set up vars to 
onready var ghost_handler = $Ghost
var ghost_entity
var ghost_scene
var build_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a8 = int(255 * alpha)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Handle build cancellation (C)
	if Input.is_action_just_pressed("cancel_build"):
		ghost_handler.get_child(0).queue_free()
		ghost_loaded = false
	
	
	# Handle inputs to set ghost
	if ghost_loaded:
		#if Input.get
		#var ghost = load("res://DebugBlock.tscn")
		#var ghost = load("res://Scenes/Moving_Entities/Bit_Minable.tscn")
		ghost_scene = load("res://Scenes/Machines/Ghost_Machine_Miner.tscn")
		build_scene = load("res://Scenes/Machines/Machine_Miner.tscn")
		 
		ghost_entity = ghost_scene.instance()
		ghost_handler.add_child(ghost_entity)
		ghost_entity.animation_player.play("Running")
		ghost_loaded = true
	
	# Handle input to rotate
	
	var current_mouse_position = get_global_mouse_position()
	var snapped_x = helper.snap_axis(current_mouse_position.x + snap_size / 2, snap_size) - snap_size
	var snapped_y = helper.snap_axis(current_mouse_position.y + snap_size / 2, snap_size) - snap_size
	
	var build_position = Vector2(snapped_x, snapped_y)
	global_position.x = snapped_x # Force this to be in the centre of the mouse
	global_position.y = snapped_y

	# Update ghost location
	
	if ghost_loaded:
		extra_offset = ghost_entity.build_offset
	else:
		extra_offset = Vector2.ZERO
	ghost_handler.global_position = build_position + extra_offset

	# Figure out if block is placeable

	if ghost_entity.buildable:
		colour_mask = buildable_colour
	else:
		colour_mask = non_buildable_colour

	ghost_entity.sprite.modulate.r8 = colour_mask.x
	ghost_entity.sprite.modulate.g8 = colour_mask.y
	ghost_entity.sprite.modulate.b8 = colour_mask.z
	
	# Handle mouseclick
	
func _unhandled_input(event):
	if event.is_action_pressed("build"):
		if ghost_entity.buildable:
			#print("BUILD")
			var build_instance = build_scene.instance()
			build_instance.global_position = ghost_handler.global_position
			get_tree().get_current_scene().get_node("Machines").add_child(build_instance)


