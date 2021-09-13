extends KinematicBody2D

var speed = 100.0

var external_velocity = Vector2.ZERO
# TODO - get this conveyor speed from the conveyor scene object
var conveyor_speed = 0.3
export var belt_list = [] # For determining the order in which belts are seen
export var belt_dict = {} # For determining the velocity of a keyed belt
export var display_velocity = Vector2.ZERO
export var curr_position = Vector2.ZERO

# Get nodes
onready var sprite_body = $Body
onready var animator = $AnimationPlayer

func _ready():
	animator.play("Idle")


func _physics_process(_delta):
	""" Walking section
		Here, there is an animation component, which is handled by flipping the
		sprite sheet depending on the direction	
	"""
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity = _move_up(velocity)

	if Input.is_action_pressed("down"):
		velocity = _move_down(velocity)

	if Input.is_action_pressed("left"):
		velocity = _move_left(velocity)

	if Input.is_action_pressed("right"):
		velocity = _move_right(velocity)
		

	velocity = velocity.normalized()
	# Check if there is any velocity force on the player
	var external_direction = check_external_velocity(belt_list, belt_dict)
	external_velocity = external_direction * conveyor_speed
	var move_and_slide_velocity = (velocity + external_velocity) * speed
	move_and_slide(move_and_slide_velocity)
	display_velocity = move_and_slide_velocity
	
	curr_position = self.global_position

	# Add in mechanics for an idle BLIP
	if _check_if_idle():
		animator.play("Idle")
		# Allow BLIP to face mouse
		if get_global_mouse_position().x > curr_position.x && not sprite_body.flip_h:
			sprite_body.flip_h = true
		elif get_global_mouse_position().x < curr_position.x && sprite_body.flip_h:
			sprite_body.flip_h = false


func check_external_velocity(external_belt_list, external_belt_dict) -> Vector2:
	var belt_check_direction = Vector2.ZERO
	if external_belt_list.empty():
		return belt_check_direction
	else:
		var current_active_belt = external_belt_list[0]
		belt_check_direction = external_belt_dict[current_active_belt]
	belt_check_direction = belt_check_direction.normalized()
	return belt_check_direction


func _check_if_idle() -> bool:
	# Idle is not totally accurate - this just checks that a movement key isn't held down
	var input_free =  Input.is_action_pressed("down") or \
	Input.is_action_pressed("up") or \
	Input.is_action_pressed("left") or \
	Input.is_action_pressed("right")
	return not input_free
	

func _move_left(velocity) -> Vector2:
	velocity.x += -1.0
	sprite_body.flip_h = false
	animator.play("Run")
	return velocity


func _move_right(velocity) -> Vector2:
	velocity.x += 1.0
	sprite_body.flip_h = true
	animator.play("Run")
	return velocity
	
func _move_up(velocity) -> Vector2:
	velocity.y += -1.0
	animator.play("Run")
	return velocity
	
func _move_down(velocity) -> Vector2:
	velocity.y += 1.0
	animator.play("Run")
	return velocity
