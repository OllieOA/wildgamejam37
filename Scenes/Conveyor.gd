extends Area2D


export var conveyor_speed = 0.3
var conveyor_direction = Vector2.ZERO
var conveyor_velocity = Vector2.ZERO
onready var animator = $AnimationPlayer
onready var current_rotation = self.rotation_degrees

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Convey")
	# Decide the direction of the conveyer belt
	if current_rotation >= 0 and current_rotation < 1:
		conveyor_direction.x = conveyor_direction.x + 1
	elif current_rotation > 89 and current_rotation < 91:
		conveyor_direction.y = conveyor_direction.y + 1
	elif current_rotation > 179 and current_rotation < 181:
		conveyor_direction.x = conveyor_direction.x + -1
	elif current_rotation > 269 and current_rotation < 271:
		conveyor_direction.y = conveyor_direction.y + -1
	else:
		print("BELT ROTATION INVALID")

	conveyor_velocity = conveyor_speed * conveyor_direction.normalized()

func _physics_process(_delta):
	for body in self.get_overlapping_bodies():
		body.belt_dict[str(self.get_name())] = conveyor_velocity


func _on_Conveyor_body_entered(body: KinematicBody2D):
#	# Add the belt to the end of the list
	body.belt_list.push_back(str(self.get_name()))
	# Initialise it in the dict
	body.belt_dict[str(self.get_name())] = conveyor_velocity


func _on_Conveyor_body_exited(body: Node) -> void:
	body.belt_list.pop_front()
	# TODO: HANDLE CLEARING OF THE BELT DICT
	#body.belt_dict.erase(str(self.get_name()))
	
