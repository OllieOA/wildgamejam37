extends Popup

onready var border = $Border
onready var title = $Border/Margin/VBox/ValueTitle
var baseline_height = 70

var colour_string_true = Color("08D208")
var colour_string_false = Color("D20808")

func _ready():
	border.rect_size.y = baseline_height

func set_label_value(body: StaticBody2D, bit, pos):
	var node_to_get = "Border/Margin/VBox/bit_" + str(pos + 1)
	# Text to set
	var curr_qty = body.quantity_delivered[bit]
	var desired_qty = body.desired_quantities[bit]
	var check_bits_delivered = body.bits_delivered[bit]
	
	var text_to_set = str(bit) + ": " + str(curr_qty) + "/" + str(desired_qty)
	
	get_node(node_to_get).set_text(text_to_set)
	# Set color
	
	if check_bits_delivered:
		get_node(node_to_get).set("custom_colors/font_color", colour_string_true)
	else:
		get_node(node_to_get).set("custom_colors/font_color", colour_string_false)
	
	# Resize (DOESN'T WORK)
	var add_to_height = get_node(node_to_get).get_line_height()
	baseline_height += add_to_height
	

