extends Control

# Preload sprites

onready var slot_1 = $TextureRect/Margin/HBox/slot_1
onready var slot_2 = $TextureRect/Margin/HBox/slot_2
onready var slot_3 = $TextureRect/Margin/HBox/slot_3
onready var slot_4 = $TextureRect/Margin/HBox/slot_4
onready var slot_5 = $TextureRect/Margin/HBox/slot_5
onready var slot_6 = $TextureRect/Margin/HBox/slot_6
onready var slot_7 = $TextureRect/Margin/HBox/slot_7
onready var slot_8 = $TextureRect/Margin/HBox/slot_8
onready var slot_9 = $TextureRect/Margin/HBox/slot_9

var slot_1_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_1_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_1_belt.png")}
var slot_2_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_2_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_2_splitter.png")}
var slot_3_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_3_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_3_miner.png")}
var slot_4_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_4_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_4_stacker.png")}
var slot_5_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_5_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_5_flipper.png")}
var slot_6_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_6_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_6_or.png")}
var slot_7_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_7_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_7_locked.png")}
var slot_8_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_8_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_8_bytestacker.png")}

var slot_9_sprite = {"locked": preload("res://Assets/Art/UI/ui_hotbar_9_speed_locked.png"),
			"unlocked": preload("res://Assets/Art/UI/ui_hotbar_9_speed_mode.png"),
			"exhausted": preload("res://Assets/Art/UI/ui_hotbar_9_speed_mode_exhausted.png"),
			"active": preload("res://Assets/Art/UI/ui_hotbar_9_speed_mode_active.png")}

var slot_1_display
var slot_2_display
var slot_3_display
var slot_4_display
var slot_5_display
var slot_6_display
var slot_7_display
var slot_8_display
var slot_9_display


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var unlock_timer = Timer.new()
	add_child(unlock_timer)
	unlock_timer.set_wait_time(1.0)
	unlock_timer.connect("timeout", self, "_on_unlock_timeout")
	unlock_timer.start()


func _process(delta: float) -> void:
	rect_position = get_tree().get_current_scene().get_node("BLIP/MainCamera").position
	
	if unlocker.speed_mode:
		if not world_parameters.speed_mode_available and world_parameters.speed_mode_active:
			slot_9_display = slot_9_sprite["active"]
			slot_9.texture = slot_9_display
		elif not world_parameters.speed_mode_available and not world_parameters.speed_mode_active: 
			slot_9_display = slot_9_sprite["exhausted"]
			slot_9.texture = slot_9_display
		else:
			slot_9_display = slot_9_sprite["unlocked"]
			slot_9.texture = slot_9_display


func _on_unlock_timeout():
	# Get unlock status
	if unlocker.bit_conveyor:
		slot_1_display = slot_1_sprite["unlocked"]
	else:
		slot_1_display = slot_1_sprite["locked"]
		
	if unlocker.splitter:
		slot_2_display = slot_2_sprite["unlocked"]
	else:
		slot_2_display = slot_2_sprite["locked"]
		
	if unlocker.miner:
		slot_3_display = slot_3_sprite["unlocked"]
	else:
		slot_3_display = slot_3_sprite["locked"]
		
	if unlocker.bit_stacker:
		slot_4_display = slot_4_sprite["unlocked"]
	else:
		slot_4_display = slot_4_sprite["locked"]
		
	if unlocker.flipper:
		slot_5_display = slot_5_sprite["unlocked"]
	else:
		slot_5_display = slot_5_sprite["locked"]
		
	if unlocker.or_builder:
		slot_6_display = slot_6_sprite["unlocked"]
	else:
		slot_6_display = slot_6_sprite["locked"]
		
	if unlocker.byte_conveyor:
		slot_7_display = slot_7_sprite["unlocked"]
	else:
		slot_7_display = slot_7_sprite["locked"]
		
	if unlocker.byte_stacker:
		slot_8_display = slot_8_sprite["unlocked"]
	else:
		slot_8_display = slot_8_sprite["locked"]
		
	if unlocker.speed_mode:
		slot_9_display = slot_9_sprite["unlocked"]
	else:
		slot_9_display = slot_9_sprite["locked"]
		
	# Update sprites
	slot_1.texture = slot_1_display
	slot_2.texture = slot_2_display
	slot_3.texture = slot_3_display
	slot_4.texture = slot_4_display
	slot_5.texture = slot_5_display
	slot_6.texture = slot_6_display
	slot_7.texture = slot_7_display
	slot_8.texture = slot_8_display
	slot_9.texture = slot_9_display
