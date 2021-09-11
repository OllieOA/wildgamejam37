extends KinematicBody2D

var speed = 100.0

# Get nodes
onready var sprite_body = $Body
onready var animator = $AnimationPlayer

func _physics_process(delta):
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
	move_and_slide(velocity * speed)


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
