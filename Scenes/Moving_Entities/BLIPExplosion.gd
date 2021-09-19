extends Particles2D

var base = preload("res://Assets/Art/Characters/BLIP_base_actual.png")
var flipped = preload("res://Assets/Art/Characters/BLIP_base_actual_flipped.png")

onready var audio_player = $AudioStreamPlayer2D
var stream_list = [
	"res://Assets/Sounds/bit_break1.ogg",
	"res://Assets/Sounds/bit_break2.ogg",
	"res://Assets/Sounds/bit_break3.ogg",
	"res://Assets/Sounds/bit_break4.ogg"
]

func initialize(sprite : Sprite, flip: bool):
	
#	var frame = sprite.get_frame()
#	var sprite_frames = sprite.get_sprite_frames()
#	var sprite_texture = sprite_frames.get_frame("default", frame)
##	var frames = Vector2(sprite.get_hframes(), sprite.get_vframes())
##	var texture_size = sprite_texture.get_size()
##	var frame_size = texture_size / frames
#
#	process_material.set_shader_param("emission_box_extents",
#		Vector3(sprite_texture.get_size().x / 2.0, sprite_texture.get_size().y / 2.0, 1))
#
	#process_material.set_shader_param("sprite", sprite)
#	#process_material.set_shader_param("sprite", sprite_to_draw)
#
	# amount = sprite.get_width() * sprite.get_height() * 2
#	amount = 3000

	if flip:
		process_material.set_shader_param("sprite", flipped)
	else:
		process_material.set_shader_param("sprite", base)


	# Audio stuff
	var stream_to_play = stream_list[randi() % stream_list.size()]
	emitting = true
	audio_player.stream = load(stream_to_play)
	audio_player.play()
	
	
