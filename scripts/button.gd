extends Button

func _on_Button_pressed() -> void:
	print("Signal received! Changing scene...")

	var scene_path = "res://scenes/node_2d.tscn"
	var new_scene = load(scene_path).instance()  # Use load to load and instance the scene
	
	if new_scene == null:
		print("Failed to instance the scene.")
		return

	get_tree().current_scene.queue_free()  # Remove the current scene
	get_tree().root.add_child(new_scene)  # Add the new scene
	get_tree().current_scene = new_scene  # Update the current scene
	
	print("Scene changed successfully.")
