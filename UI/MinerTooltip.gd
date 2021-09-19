extends Popup

var bit_value 

func _ready():
		
	get_node("Border/Margin/VBox/ValueString").set_text(str(bit_value))


