extends KinematicBody2D

var speed = 100.0

var external_velocity = Vector2.ZERO
var belt_list: Array = [] # For determining the order in which belts are seen
var belt_dict: Dictionary = {} # For determining the velocity of a keyed belt
var curr_position = Vector2.ZERO

# Get nodes
onready var sprite_body = $Body
onready var animator = $AnimationPlayer
onready var activity_checker = $ActivityChecker
var blip_particles
var Particle_Explosion = preload("res://Scenes/Moving_Entities/BLIPExplosion.tscn")
var prevent_movement
var destroying_blip = false


func _ready():
	prevent_movement = false
	animator.play("Idle")
		
	# Initialise the belt vars
	belt_list = []
	belt_dict = {}
	
	blip_particles = load("res://Assets/Art/Characters/BLIP_base_actual.png")


func _process(delta: float) -> void:
	
	if unlocker.destroy_blip and not destroying_blip:
		destroying_blip = true
		destroy_blip()


func _physics_process(_delta):
	""" Walking section
		Here, there is an animation component, which is handled by flipping the
		sprite sheet depending on the direction	
	"""
	# Check if any belts are in range to add to the dict
	for area in activity_checker.get_overlapping_areas():
		if "Machine_Conveyor" in area.get_name():
			belt_dict[area.get_name()] = area.conveyor_velocity
	
	
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
	var move_and_slide_velocity = Vector2.ZERO
	
	if not belt_dict.empty():
		var external_direction = check_external_velocity()
		external_velocity = external_direction * world_parameters.conveyor_speed
		move_and_slide_velocity = (velocity + external_velocity) * speed
	else:
		move_and_slide_velocity = velocity * speed
	if not prevent_movement:
		move_and_slide(move_and_slide_velocity)
	
	curr_position = self.global_position

	# Add in mechanics for an idle BLIP
	if _check_if_idle() and not prevent_movement:
		animator.play("Idle")
		# Allow BLIP to face mouse
		if get_global_mouse_position().x > curr_position.x && not sprite_body.flip_h:
			sprite_body.flip_h = true
		elif get_global_mouse_position().x < curr_position.x && sprite_body.flip_h:
			sprite_body.flip_h = false


func check_external_velocity():
	var belt_check_direction = Vector2.ZERO
	if belt_list.empty():
		return belt_check_direction
	else:
		var current_active_belt = belt_list[0]
		belt_check_direction = belt_dict[current_active_belt]
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
	
func destroy_blip():
	# Destroy and explode
	
	prevent_movement = true
	var timer = Timer.new()
	self.add_child(timer)
	
	# Add particle effect and remove sprite
	var particle_effect = Particle_Explosion.instance()
	particle_effect.global_position = global_position + Vector2(12.5, 12.5)
	get_tree().get_current_scene().add_child(particle_effect)
	particle_effect.initialize(blip_particles, sprite_body.flip_h)
	sprite_body.visible = false
	
#	# Time to scene destruction
#	timer.connect("timeout", self, "queue_free")
#	timer.set_wait_time(particle_effect.lifetime)
#	timer.start()
