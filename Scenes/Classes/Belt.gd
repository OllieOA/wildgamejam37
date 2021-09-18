extends Area2D
class_name Belt

var conveyor_velocity
var conveyor_direction
onready var animator = $AnimationPlayer

func _ready():
	
	conveyor_direction = Vector2.ZERO
	conveyor_velocity = Vector2.ZERO
	
	animator.add_to_group("belt_animations", true)
	animator.play("Convey")
	
	# Decide the direction of the conveyer belt
	var current_rotation = rotation_degrees
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

	conveyor_velocity = world_parameters.conveyor_speed * conveyor_direction.normalized()
	

func _on_Conveyor_body_entered(body: KinematicBody2D):
#	# Add the belt to the end of the list
	body.belt_list.push_back(str(self.get_name()))
	# Initialise it in the dict
	body.belt_dict[str(self.get_name())] = conveyor_velocity


func _on_Conveyor_body_exited(body: Node) -> void:
	body.belt_list.pop_front()
