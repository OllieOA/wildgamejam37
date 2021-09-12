extends KinematicBody2D

# Debug vars
export var display_velocity = Vector2.ZERO

# External vars
export var bit_string = "1"
export var belt_list = [] # For determining the order in which belts are seen
export var belt_dict = {} # For determining the velocity of a keyed belt
export var curr_position = Vector2.ZERO
var conveyor_speed = 0.3

# Internal vars
onready var bit_centre = $bit_centre
var external_velocity = Vector2.ZERO
var base_speed = 100
var bit_mineable_dict = {
	"0110": 0,
	"1": 1,
	"0": 2,
	"10": 3
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get frame for bit object
	var frame_to_use = bit_mineable_dict[bit_string]
	$Sprite.frame = frame_to_use


func _process(delta):
	
	# Update and expose centre pos
	curr_position = bit_centre.global_position
	
	# Move item based on belt physics
	var velocity = Vector2.ZERO
	var external_direction = check_external_velocity(belt_list, belt_dict)
	external_velocity = external_direction * conveyor_speed
	var move_and_slide_velocity = (external_velocity + velocity) * base_speed
	move_and_slide(move_and_slide_velocity)
	display_velocity = move_and_slide_velocity
	
	# Correct position based on travel direction
	

func check_external_velocity(external_belt_list, external_belt_dict) -> Vector2:
	var belt_check_direction = Vector2.ZERO
	if external_belt_list.empty():
		return belt_check_direction
	else:
		var current_active_belt = external_belt_list[0]
		belt_check_direction = external_belt_dict[current_active_belt]
	belt_check_direction = belt_check_direction.normalized()
	return belt_check_direction
