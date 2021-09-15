extends Node2D


func test_call(test_var):
	print(str(test_var))


func snap_axis(original_position, snap_size):
	var grid_num_to_snap = round(original_position / snap_size)
	var new_pos = snap_size * grid_num_to_snap
	return new_pos
