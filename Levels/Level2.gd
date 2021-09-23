extends Node2D

onready var music_player = $GameMusic
onready var margin_container = $CanvasLayer/MarginContainer
onready var level_camera = $BLIP/MainCamera
onready var blip_instance = $BLIP
onready var cursor_instance = $GridCursor
onready var background_square = $Background

var level_bound_r
var level_bound_l
var level_bound_u
var level_bound_d
var next_level

func _ready():
	next_level = "res://Levels/Level3.tscn"
	unlocker.current_level = 2
	
	# Open in fullscreen
	OS.window_fullscreen = true
	
	# Play background music
	music_player.play()
	margin_container.show()
	
	level_bound_r = 300
	level_bound_l = 0
	level_bound_u = 0
	level_bound_d = 300
	
	# Figure out how big to draw the background
	# Assume all levels are bounded at 0, 0
	var horizontal_scale = level_bound_r / 1000.0
	var vertical_scale = level_bound_d / 1000.0
	
	print(horizontal_scale)
	
	background_square.scale = Vector2(horizontal_scale, vertical_scale)


func _process(delta: float) -> void:
	# Clamp BLIP
	blip_instance.global_position.x = clamp(blip_instance.global_position.x, level_bound_l - 8, level_bound_r - 16)
	blip_instance.global_position.y = clamp(blip_instance.global_position.y, level_bound_u - 12, level_bound_d - 24)
