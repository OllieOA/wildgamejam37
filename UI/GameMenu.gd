extends Control


onready var sfx_bus_id = AudioServer.get_bus_index("Master")
onready var music_bus_id = AudioServer.get_bus_index("Music")
onready var menu_clicker = $MenuClick

var base_sfx_bus_vol
var base_music_bus_vol
var sfx_modifier
var music_modifier

func _ready() -> void:
	self.hide()
	
	sfx_modifier = 1.0
	music_modifier = 1.0
	base_sfx_bus_vol = AudioServer.get_bus_volume_db(sfx_bus_id)
	base_music_bus_vol = AudioServer.get_bus_volume_db(music_bus_id)
	

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("GameMenu") and not self.visible:
		self.show()
		get_tree().paused = true
	elif event.is_action_pressed("GameMenu") and self.visible:
		self.hide()
		get_tree().paused = false

func _on_ExitButton_pressed() -> void:
	menu_clicker.play()
	SaveState.save_game()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()


func _on_CloseMenu_pressed() -> void:
	menu_clicker.play()
	self.hide()
	get_tree().paused = false


func _on_ToggleMusic_pressed() -> void:
	menu_clicker.play()
	# Reduce level incrementally, unless mute
	# Or just mute
	AudioServer.set_bus_mute(music_bus_id, not AudioServer.is_bus_mute(music_bus_id))
	
#	music_modifier -= 0.3
#	if music_modifier < 0.3:
#		music_modifier = 1.3  # Ready for turning on
#		AudioServer.set_bus_mute(music_bus_id, true)
#	elif music_modifier > 0.99 and music_modifier < 1.01:
#		AudioServer.set_bus_mute(music_bus_id, false)
#		AudioServer.set_bus_volume_db(music_bus_id, base_music_bus_vol)
#	else:
#		AudioServer.set_bus_volume_db(music_bus_id, linear2db(music_modifier - (0.6*music_modifier)))


func _on_ToggleSFX_pressed() -> void:
	menu_clicker.play()
	# Reduce level incrementally, unless mute
	# Or just mute
	AudioServer.set_bus_mute(sfx_bus_id, not AudioServer.is_bus_mute(sfx_bus_id))
#	sfx_modifier -= 0.3
#	if sfx_modifier < 0.3:
#		sfx_modifier = 1.3  # Ready for turning on
#		AudioServer.set_bus_mute(sfx_bus_id, true)
#	elif sfx_modifier > 0.99 and sfx_modifier < 1.01:
#		AudioServer.set_bus_mute(sfx_bus_id, false)
#		AudioServer.set_bus_volume_db(sfx_bus_id, base_sfx_bus_vol)
#	else:
#		AudioServer.set_bus_volume_db(sfx_bus_id, linear2db(sfx_modifier - (0.6*sfx_modifier)))
