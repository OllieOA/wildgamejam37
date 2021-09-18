extends Belt

var split_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Add splitter logic
	split_direction = "L"
	# Rotate direction by -90, using vectors
	if abs(conveyor_direction.x) > 0.9:  # Rotating to vertical, accounting for floating point error
		conveyor_direction = Vector2(0, -1 * conveyor_direction.x)
	elif abs(conveyor_direction.y) > 0.9:
		conveyor_direction = Vector2(conveyor_direction.y, 0)
	conveyor_velocity = world_parameters.conveyor_speed * conveyor_direction.normalized()


func _on_Conveyor_body_exited(body: Node) -> void:
	body.belt_list.pop_front()
	
	# Flip direction and update velocity
	conveyor_direction = conveyor_direction * -1
	conveyor_velocity = world_parameters.conveyor_speed * conveyor_direction.normalized()
	
