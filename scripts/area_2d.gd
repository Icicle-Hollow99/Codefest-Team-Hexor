extends Area2D

# This function is connected to the 'body_entered' signal.
func _on_area_entered(body: Node) -> void:
	if body.name == "Shadow slime":  # Replace with your player's node name, e.g., "Player"
		body.set_checkpoint(global_position)  # Assuming you have this function in your player script
		print("Checkpoint activated at: ", global_position)
