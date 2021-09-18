extends KinematicBody2D

# Debug vars
var display_velocity = Vector2.ZERO

# External vars
export (PackedScene) var Particle_Explosion
var bit_string = "1"
var belt_list: Array = [] # For determining the order in which belts are seen
var belt_dict: Dictionary = {} # For determining the velocity of a keyed belt
var curr_position = Vector2.ZERO
var conveyor_speed = 0.3

# Internal vars
onready var bit_centre = $Bit_Centre
onready var activity_checker = $ActivityChecker
onready var sprite = $Sprite
onready var collider = $CollisionShape2D
onready var blockage_checker = $BlockageChecker
var blocked
var particle_latch = true
var mark_for_destruction = false
var mark_for_absorption = false
var external_velocity = Vector2.ZERO
var base_speed = 100
var snap_size = 8
var bit_dict = {
	"0110": 0,
	"1": 1,
	"0": 2,
	"10": 3
}

# Internal logic to handle process vs physics
var tenth_loop = false
var process_loop_counter = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get frame for bit object
	var frame_to_use = bit_dict[bit_string]
	sprite.frame = frame_to_use
	
	# Initialise the belt vars
	belt_list = []
	belt_dict = {}
	
	mark_for_destruction = false

func _process(delta):
	# Catch premature destruction with the physics system
	if not process_loop_counter > 10:
		process_loop_counter += 1
	else: 
		tenth_loop = true # Latched

	if mark_for_destruction and particle_latch:
		# Destroy and explode
		var timer = Timer.new()
		self.add_child(timer)
		
		# Add particle effect and remove sprite
		var particle_effect = Particle_Explosion.instance()
		particle_effect.global_position = bit_centre.global_position
		get_tree().get_current_scene().get_node("Units").get_node("ParticleRenderLayer").add_child(particle_effect)
		particle_effect.initialize(self.sprite)
		sprite.visible = false
		collider.disabled = true
		
		# Time to scene destruction
		timer.connect("timeout", self, "queue_free")
		timer.set_wait_time(particle_effect.lifetime)
		timer.start()
		particle_latch = false
		
	# Clean up Dict
	for belt in belt_dict.keys():
		if not (belt in belt_list):
			belt_dict.erase(belt)
	
	# Check for destruction
	if not mark_for_destruction and tenth_loop:
		
		if belt_dict.empty():
			mark_for_destruction = true

func _physics_process(delta):
	
	# Check if blocked, and if blocked, disable velocity change
	blocked = false
	if len(blockage_checker.get_overlapping_bodies()) > 1:
		blocked = true
	
	if not blocked:
		# Check if any belts are in range to add to the dict
		for area in activity_checker.get_overlapping_areas():
			if "Machine_Conveyor" in area.get_name():
				belt_dict[area.get_name()] = area.conveyor_velocity
		
		# Update and expose centre pos
		curr_position = bit_centre.global_position
		
		# Move item based on belt physics
		var velocity = Vector2.ZERO
		var external_direction = check_external_velocity()
		external_velocity = external_direction * conveyor_speed
		
		# Update velocity and determine cardinal direction
		var move_and_slide_velocity = (external_velocity + velocity) * base_speed
		move_and_slide(move_and_slide_velocity)
		display_velocity = move_and_slide_velocity
		var movement_direction = move_and_slide_velocity.normalized()
		
		# Move the directional blockage checker 
		var rotation_based_on_travel = int(rad2deg(movement_direction.angle()))
		if rotation_based_on_travel in [-90, 0, 90, 180]:
			blockage_checker.rotation_degrees = rotation_based_on_travel
		
		# Correct position based on travel direction
		if abs(movement_direction.x) > 0.9:
			# Dominant horizontal movement - adjust Y to grid snap
			var new_pos = helper.snap_axis(self.global_position.y, snap_size)
			self.global_position.y = new_pos
		elif abs(movement_direction.y) > 0.9:
			# Dominant vertical movement - adjust X to grid snap
			var new_pos = helper.snap_axis(self.global_position.x, snap_size)
			self.global_position.x = new_pos


func check_external_velocity():
	var belt_check_direction = Vector2.ZERO
	if belt_list.empty():
		return belt_check_direction
	else:
		var current_active_belt = belt_list[0]
		belt_check_direction = belt_dict[current_active_belt]
	belt_check_direction = belt_check_direction.normalized()
	return belt_check_direction
