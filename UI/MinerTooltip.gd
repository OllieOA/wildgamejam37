extends Popup

var bit_value 

func _ready():
		
	# Do a validity test
	get_node("Border/Margin/VBox/ValueString").set_text(str(bit_value))
