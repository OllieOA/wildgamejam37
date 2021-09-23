extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ConfirmationDialog.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_ConfirmationDialog_confirmed() -> void:
	SceneTransition.goto_scene("res://Scenes/MainMenu.tscn")
