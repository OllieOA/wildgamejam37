extends Sprite

var snap_size = 8
var sprite_to_build = -1
var ghost_loaded = false
var extra_offset
var alpha = 0.8
var buildable_colour = Vector3(84, 255, 20)
var non_buildable_colour = Vector3(255, 28, 28)
var colour_mask = Vector3.ZERO
var building
onready var area_checker = $AreaChecker

# Set up vars to handle ghosts
onready var ghost_handler = $Ghost
var ghost_scene_to_load
var ghost_entity
var ghost_scene
var build_scene
var build_scene_to_load
var ghost_rotation
var rotation_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a8 = int(255 * alpha)
	building = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# First, update cursor
	var current_mouse_position = get_global_mouse_position()
	var snapped_x = helper.snap_axis(current_mouse_position.x + snap_size / 2, snap_size) - snap_size
	var snapped_y = helper.snap_axis(current_mouse_position.y + snap_size / 2, snap_size) - snap_size
	
	var build_position = Vector2(snapped_x, snapped_y)
	global_position.x = snapped_x # Force this to be in the centre of the mouse
	global_position.y = snapped_y
	
	# Handle build cancellation (C)
	if Input.is_action_just_pressed("cancel_build"):
		remove_current_ghost()
		ghost_loaded = false
		building = false
	
	# Handle inputs to set ghost
	if Input.is_action_just_pressed("selector_1"):
		# Conveyor
		remove_current_ghost()  # Clear current selection
		print("Conveyor selected")
		ghost_scene_to_load = "res://Scenes/Machines/Ghost_Machine_Conveyor.tscn"
		build_scene_to_load = "res://Scenes/Machines/Machine_Conveyor.tscn"
		building = true
		load_ghost()
	if Input.is_action_just_pressed("selector_2"):
		# Miner
		remove_current_ghost()  # Clear current selection
		print("Miner selected")
		ghost_scene_to_load = "res://Scenes/Machines/Ghost_Machine_Miner.tscn"
		build_scene_to_load = "res://Scenes/Machines/Machine_Miner.tscn"
		building = true
		load_ghost()
	if Input.is_action_just_pressed("selector_3"):
		building = true
	if Input.is_action_just_pressed("selector_4"):
		building = true
	if Input.is_action_just_pressed("selector_5"):
		building = true
	if Input.is_action_just_pressed("selector_6"):
		building = true
	if Input.is_action_just_pressed("selector_7"):
		building = true
	if Input.is_action_just_pressed("selector_8"):
		building = true
	if Input.is_action_just_pressed("selector_9"):
		building = true
	if Input.is_action_just_pressed("selector_0"):
		building = true

	if building:
		# Handle input to rotate
		
		if Input.is_action_just_pressed("rotate_clockwise"):
			if ghost_handler.rotation_degrees > 269:
				ghost_handler.rotation_degrees = 0
			else:
				ghost_handler.rotation_degrees += 90
		
		var rotation_offset_amounts = ghost_entity.rotation_offset[int(ghost_handler.rotation_degrees)]
		rotation_offset = Vector2(rotation_offset_amounts[0], rotation_offset_amounts[1])
			
			
			
		# Update ghost position
		if ghost_loaded:
			extra_offset = ghost_entity.build_offset
		else:
			extra_offset = Vector2.ZERO
		ghost_handler.global_position = build_position + extra_offset + rotation_offset
		print("Updated pos: " + str(ghost_handler.global_position))
		# Figure out if block is placeable

		if ghost_entity.buildable:
			colour_mask = buildable_colour
		else:
			colour_mask = non_buildable_colour

		ghost_entity.sprite.modulate.r8 = colour_mask.x
		ghost_entity.sprite.modulate.g8 = colour_mask.y
		ghost_entity.sprite.modulate.b8 = colour_mask.z
	

# Handle mouseclick to build
	
func _unhandled_input(event):
	if event.is_action_pressed("build") and building:
		if ghost_entity.buildable:
			build_scene = load(build_scene_to_load)
			var build_instance = build_scene.instance()
			build_instance.rotation_degrees = ghost_handler.rotation_degrees
			build_instance.global_position = ghost_handler.global_position# + rotation_offset
			
			var destination_node = "Machines"
			if "Conveyor" in build_scene_to_load:
				destination_node = "Machines_Conveyors"
				
			get_tree().get_current_scene().get_node(destination_node).add_child(build_instance)
		else:
			pass


func remove_current_ghost():
	if ghost_handler.get_child_count() > 0:
		for child in ghost_handler.get_children():
			child.queue_free()


func load_ghost():
	ghost_scene = load(ghost_scene_to_load)
	ghost_entity = ghost_scene.instance()
	ghost_handler.add_child(ghost_entity)
	ghost_entity.animation_player.play("Running")
	ghost_loaded = true
