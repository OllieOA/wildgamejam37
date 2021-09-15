extends Particles2D

onready var audio_player = $AudioStreamPlayer2D
var stream_list = [
	"res://Assets/Sounds/bit_break1.ogg",
	"res://Assets/Sounds/bit_break2.ogg",
	"res://Assets/Sounds/bit_break3.ogg",
	"res://Assets/Sounds/bit_break4.ogg"
]

func initialize(sprite : AnimatedSprite):
	
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
#	process_material.set_shader_param("sprite", sprite_texture)
#	#process_material.set_shader_param("sprite", sprite_to_draw)
#
#	# amount = sprite.texture.get_width() * sprite.texture.get_height() * 2
#	amount = 3000


	# Audio stuff
	var stream_to_play = stream_list[randi() % stream_list.size()]
	emitting = true
	audio_player.stream = load(stream_to_play)
	audio_player.play()
	
	
