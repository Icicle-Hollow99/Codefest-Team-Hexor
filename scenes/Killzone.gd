extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("is_invincible") and body.is_invincible:
		print("Player is invincible, ignoring kill zone.")  # Debugging
		return  # Ignore kill zone if the player is invincible

	


	print(body.name)
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
