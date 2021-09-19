extends StaticBody2D

var blip_in_range
onready var prompt_player = $Prompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blip_in_range = false
	$AnimationPlayer.play("Idle")

func _process(delta: float) -> void:
	if blip_in_range:
		if not prompt_player.visible:
			prompt_player.show()
		if Input.is_action_just_pressed("activate"):
			# CHOOSE DIALOGUE
			
			pass
	else:
		if prompt_player.visible:
			prompt_player.hide()

func _on_Dialogue_Checker_body_entered(body: Node) -> void:
	blip_in_range = true


func _on_Dialogue_Checker_body_exited(body: Node) -> void:
	blip_in_range = false
