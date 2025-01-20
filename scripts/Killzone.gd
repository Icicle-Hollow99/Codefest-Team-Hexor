extends Area2D

@export var destination: NodePath  # Assign portal node path in the inspector

func _ready():
	if destination.is_empty():
		print("Warning: Destination portal not set in the editor!")
	else:
		print("Destination set to:", destination)

	# Connect the signal if not connected already
	if not self.body_entered.is_connected(_on_body_entered):
		self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Body entered:", body.name)
	if body.name == "Shadow slime" and not destination.is_empty():
		var target_portal = get_node(destination)
		if target_portal:
			print("Teleporting to:", target_portal.global_position)
			body.global_position = target_portal.global_position
		else:
			print("Error: Target portal not found:", destination)
