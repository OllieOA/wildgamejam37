extends Node2D

var buildable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buildable = false
	$Sprite.hide()
	$Build_Check_Area.hide()

