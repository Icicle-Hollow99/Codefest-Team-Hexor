

extends Area2D

@export var destination: NodePath  # Declare the destination

# Assign the default value in the _ready function or in the editor
func _ready():
	if destination == null:
		destination = "res://scenes/Portal.tscn"

func _on_body_entered(body):
	if body.name == "Shadow slime" and destination:
		var target_portal = get_node(destination)
		if target_portal:
			body.global_position = target_portal.global_position
		else:
			print("Error: Target portal not found at:", destination)
