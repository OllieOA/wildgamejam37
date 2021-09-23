extends Node2D

onready var animator = $Sprite/AnimationPlayer
onready var splash_text = $SplashText
onready var time_dilation = $TimeDilation
onready var pulse_up = $PulseUp
onready var second_pulse_up = $PulseUp2
onready var main_menu_selections = $MainMenu_Selections
onready var tween_values_1 = [0.9, 1.1]
onready var tween_values_2 = [0.9, 1.1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.window_fullscreen = true
	animator.play("TitleAnimation")
	main_menu_selections.show()


