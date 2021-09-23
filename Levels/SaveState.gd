extends Node

var save_filename = "user://blip_save_game.save"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func save_game():
	var save_file = File.new()
	save_file.open(save_filename, File.WRITE)
	var save_data = [unlocker.max_level_reached]
	save_file.store_line(to_json(save_data))

	save_file.close()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()

func load_game():
	var save_file = File.new()
	if not save_file.file_exists(save_filename):
		return

	save_file.open(save_filename, File.READ)
	var node_data = parse_json(save_file.get_line())
	unlocker.max_level_reached = node_data[0]
