extends Control

onready var menu_clicker = $MenuClick
var levels = {
	"level_1": "res://Levels/Level1.tscn",
	"level_2": "res://Levels/Level2.tscn",
	"level_3": "res://Levels/Level3.tscn",
	"level_4": "res://Levels/Level4.tscn",
	"level_5": "res://Levels/Level5.tscn",
	"level_6": "res://Levels/Level6.tscn",
	"level_7": "res://Levels/Level7.tscn",
	"level_8": "res://Levels/Level8.tscn"
}

func _on_NewGame_pressed() -> void:
	# Start a new game by transitioning to the first scene
	unlocker.max_level_reached = 0
	menu_clicker.play()
	# Level 1
	SceneTransition.goto_scene(levels["level_1"])


func _on_Continue_pressed() -> void:
	# Load up at the max level
	SaveState.load_game()
	if unlocker.max_level_reached > 0:
		var level_to_goto = "level_" + str(unlocker.max_level_reached)
		SceneTransition.goto_scene(levels[level_to_goto])
		pass


func _on_ExitButton_pressed() -> void:
	menu_clicker.play()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()
