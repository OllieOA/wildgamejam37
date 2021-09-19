extends Sprite

onready var bit_tool_tip = preload("res://UI/BitTooltip.tscn")
onready var miner_tool_tip = preload("res://UI/MinerTooltip.tscn")
onready var file_tool_tip = preload("res://UI/FileTooltip.tscn")

var base_texture = "res://Assets/Art/UI/ui_build_cursor.png"
var destroy_texture = "res://Assets/Art/UI/ui_destroy_cursor.png"

var snap_size = 8
var sprite_to_build = -1
var ghost_loaded = false
var extra_offset
var alpha = 0.8
var buildable_colour = Vector3(84, 255, 20)
var non_buildable_colour = Vector3(255, 28, 28)
var colour_mask = Vector3.ZERO
var building
var destroying
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
var build_position

# Tooltip vars
var tooltip_showing
var current_tooltip_body
var destroying_tooltip
onready var build_select_tooltip_text = $Label
onready var build_select_tooltip_tween = $Label/Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a8 = int(255 * alpha)
	building = false
	destroying = false
	tooltip_showing = false
	destroying_tooltip = false
	build_position = Vector2.ZERO
	
	build_select_tooltip_text.modulate.a8 = 0

func _process(_delta) -> void:
	
	#  Update cursor position and snap to axis
	var current_mouse_position = get_global_mouse_position()
	var snapped_x = helper.snap_axis(current_mouse_position.x + snap_size / 2, snap_size) - snap_size
	var snapped_y = helper.snap_axis(current_mouse_position.y + snap_size / 2, snap_size) - snap_size
	
	build_position = Vector2(snapped_x, snapped_y)
	global_position.x = snapped_x # Force this to be in the centre of the mouse
	global_position.y = snapped_y
	
	# Test for tooltip triggering
	if not tooltip_showing:
		for body in area_checker.get_overlapping_bodies():
			if "Bit" in body.get_name():
				current_tooltip_body = body.get_name()
				# Instance the tooltip
				instance_tooltip(bit_tool_tip, body, "Bit")
				
			elif "Miner" in body.get_name():
				current_tooltip_body = body.get_name()
				# Instance the tooltip
				instance_tooltip(miner_tool_tip, body, "Miner")
				
			elif "File" in body.get_name():
				current_tooltip_body = body.get_name()
				instance_tooltip(file_tool_tip, body, "File")
				
				# Instance the tooltip
				
	if tooltip_showing:
		if not current_tooltip_body in area_checker.get_overlapping_bodies() and not destroying_tooltip:
			destroying_tooltip = true
			var timer_tooltip_destroy = Timer.new()
			timer_tooltip_destroy.one_shot = true
			add_child(timer_tooltip_destroy)
			timer_tooltip_destroy.set_wait_time(1)
			timer_tooltip_destroy.connect("timeout", self, "_on_tooltip_destory_timeout")
			timer_tooltip_destroy.start()

	# Test to see if tooltip has died
#	if tooltip_showing:
#		if tooltip_instance.
		
	
	# Handle build cancellation (C)
	if Input.is_action_just_pressed("cancel_build"):
		remove_current_ghost()
		ghost_loaded = false
		building = false
		destroying = false
		texture = load(base_texture)
		
	# Handle destroy selection (X or Del)
	if Input.is_action_just_pressed("destruction_key"):
		remove_current_ghost()
		ghost_loaded = false
		building = false
		destroying = true
		texture = load(destroy_texture)
	
	# Handle inputs to set ghost
	if Input.is_action_just_pressed("selector_1"):
		# Conveyor
		if unlocker.bit_conveyor:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("BIT CONVEYOR")
			ghost_scene_to_load = "res://Scenes/Machines/Ghost_Machine_Conveyor.tscn"
			build_scene_to_load = "res://Scenes/Machines/Machine_Conveyor.tscn"
			building = true
			load_ghost()
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false
	if Input.is_action_just_pressed("selector_2"):
		# Splitter
		if unlocker.splitter:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("SPLITTER")
			ghost_scene_to_load = "res://Scenes/Machines/Ghost_Machine_Splitter.tscn"
			build_scene_to_load = "res://Scenes/Machines/Machine_Splitter.tscn"
			building = true
			load_ghost()
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false
	if Input.is_action_just_pressed("selector_3"):
		# Miner
		if unlocker.miner:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("MINER")
			ghost_scene_to_load = "res://Scenes/Machines/Ghost_Machine_Miner.tscn"
			build_scene_to_load = "res://Scenes/Machines/Machine_Miner.tscn"
			building = true
			load_ghost()
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false
	if Input.is_action_just_pressed("selector_4"):
		# Bit Stacker
		if unlocker.bit_stacker:
			building = true
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false
	if Input.is_action_just_pressed("selector_5"):
		# Flipper
		if unlocker.flipper:
			remove_current_ghost()
			show_build_select_tooltip("FLIPPER")
			ghost_scene_to_load = "res://Scenes/Machines/Ghost_Machine_Flipper.tscn"
			build_scene_to_load = "res://Scenes/Machines/Machine_Flipper.tscn"
			building = true
			load_ghost()
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false
	if Input.is_action_just_pressed("selector_6"):
		# OR Builder
		if unlocker.or_builder:
			building = true
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false
	if Input.is_action_just_pressed("selector_7"):
		# Byte Conveyor
		if unlocker.byte_conveyor:
			building = true
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false
	if Input.is_action_just_pressed("selector_8"):
		# Byte Stacker
		if unlocker.byte_stacker:
			building = true
		else:
			remove_current_ghost()  # Clear current selection
			show_build_select_tooltip("NOT YET UNLOCKED")
			building = false

	if building:
		# Handle input to rotate
		
		if Input.is_action_just_pressed("rotate_clockwise") and not Input.is_action_just_pressed("rotate_anticlockwise"):
			if ghost_handler.rotation_degrees > 269:
				ghost_handler.rotation_degrees = 0
			else:
				ghost_handler.rotation_degrees += 90
				
		if Input.is_action_just_pressed("rotate_anticlockwise"):  # This is a modifier, so it needs to be caught
			if ghost_handler.rotation_degrees < 1:
				ghost_handler.rotation_degrees = 270
			else:
				ghost_handler.rotation_degrees -= 90
		
		var rotation_offset_amounts = ghost_entity.rotation_offset[int(ghost_handler.rotation_degrees)]
		rotation_offset = Vector2(rotation_offset_amounts[0], rotation_offset_amounts[1])

		# Update ghost position
		if ghost_loaded:
			extra_offset = ghost_entity.build_offset
		else:
			extra_offset = Vector2.ZERO
		ghost_handler.global_position = build_position + extra_offset + rotation_offset
		
		# Figure out if block is placeable

		if ghost_entity.buildable:
			colour_mask = buildable_colour
		else:
			colour_mask = non_buildable_colour

		ghost_entity.modulate.r8 = colour_mask.x
		ghost_entity.modulate.g8 = colour_mask.y
		ghost_entity.modulate.b8 = colour_mask.z
		
	# Handle clicking
	if Input.is_action_just_pressed("build") and building:
		if ghost_entity.buildable:
			build_scene = load(build_scene_to_load)
			var build_instance = build_scene.instance()
			build_instance.rotation_degrees = ghost_handler.rotation_degrees
			build_instance.global_position = ghost_handler.global_position
			if not ghost_entity.get("miner_bit_string") == null:
				# This is a miner
				build_instance.bit_string = ghost_entity.miner_bit_string
			
			var destination_node = "Machines"
			if "Conveyor" in build_scene_to_load:
				destination_node = "Machines_Conveyors"
			if "Splitter" in build_scene_to_load:
				destination_node = "Machines_Conveyors"
				
			get_tree().get_current_scene().get_node(destination_node).add_child(build_instance)
		else:
			pass
	elif Input.is_action_just_pressed("build") and destroying:
		# Temporarily enable collision for machine layers
		update_collision_mask(true)
		var nodes_to_delete = []
		for body in area_checker.get_overlapping_bodies():
			if "Machine" in body.get_name():
				nodes_to_delete.append(body)
		for area in area_checker.get_overlapping_areas():
			if "Machine" in area.get_name():
				nodes_to_delete.append(area)
		for node in nodes_to_delete:
			node.queue_free()
			
		update_collision_mask(false)


func instance_tooltip(tooltip_to_instance, body, type):
	# Instance the tooltip
	var tooltip_instance = tooltip_to_instance.instance()
	tooltip_instance.rect_scale = Vector2(0.25, 0.25)
	tooltip_instance.rect_position = build_position + Vector2(16, 0)
	
	# Populate the tooltip based on the type
	if type == "Miner":
		tooltip_instance.bit_value = body.bit_string
	if type == "Bit":
		tooltip_instance.bit_value = body.bit_string
	if type == "File":
		# Get all the desired bits and their status
		var desired_bits = body.desired_bit_strings
		var bit_status = body.bits_delivered
		for bit_num in range(len(desired_bits)):
			# Get the status and show it as either green or red
			var curr_bit_string = desired_bits[bit_num]
			tooltip_instance.set_label_value(body, curr_bit_string, bit_num)
		
	
	add_child(tooltip_instance)
	tooltip_showing = true
	yield(get_tree().create_timer(0.1), "timeout")
	if has_node("Tooltip"):
		get_node("Tooltip").show()
		

func remove_current_ghost():
	texture = load(base_texture)
	if ghost_handler.get_child_count() > 0:
		for child in ghost_handler.get_children():
			child.queue_free()


func load_ghost():
	ghost_scene = load(ghost_scene_to_load)
	ghost_entity = ghost_scene.instance()
	ghost_handler.add_child(ghost_entity)
	ghost_entity.animation_player.play("Running")
	ghost_loaded = true


func update_collision_mask(setting):
	area_checker.set_collision_mask_bit(2, setting)
	area_checker.set_collision_mask_bit(3, setting)
	area_checker.set_collision_mask_bit(4, not setting)
	area_checker.set_collision_mask_bit(5, not setting)


func _on_tooltip_destory_timeout():
	if get_node("Tooltip") != null:
		get_node("Tooltip").queue_free()
	tooltip_showing = false
	destroying_tooltip = false


func show_build_select_tooltip(selection):
	build_select_tooltip_text.set_text(selection)
	build_select_tooltip_text.modulate.a8 = 255
	#yield(get_tree().create_timer(0.3), "timeout")
	if build_select_tooltip_tween.is_active():
		build_select_tooltip_tween.stop(build_select_tooltip_text)
	build_select_tooltip_tween.interpolate_property(build_select_tooltip_text, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	build_select_tooltip_tween.start()
