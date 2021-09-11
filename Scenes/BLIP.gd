extends KinematicBody2D

var speed = 100.0

var external_velocity = Vector2.ZERO
var conveyor_speed = 0.2
export var belt_dict = {}

# Get nodes
onready var sprite_body = $Body
onready var animator = $AnimationPlayer

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

	if _check_if_idle():
		animator.play("Idle")

	velocity = velocity.normalized()
	# Check if there is any velocity force on the player
	var belt_check_velocity = Vector2.ZERO
	if belt_dict.empty():
		belt_check_velocity = Vector2.ZERO
	else:
		for key in belt_dict.keys():
			belt_check_velocity += belt_dict[key]
	
	external_velocity = belt_check_velocity.normalized() * conveyor_speed
	
	move_and_slide((velocity + external_velocity) * speed)


func _check_if_idle() -> bool:
	var input_free =  Input.is_action_just_released("down") or \
	Input.is_action_just_released("up") or \
	Input.is_action_just_released("left") or \
	Input.is_action_just_released("right")
	return input_free
	

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
