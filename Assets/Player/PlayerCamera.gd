class_name PlayerCamera extends Camera2D

func set_camera_offset(origin: Vector2, offset: Vector2, max_distance = 150):
	return
	var target_position = origin + offset
	if origin.distance_to(target_position) <= max_distance:
		position = target_position
		print("in dist")
	#else:
		#position = origin
		#print("out of dist")
