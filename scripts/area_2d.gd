extends Area2D

@export var destination: NodePath  # Declare the destination

# Assign the default value in the _ready function or in the editor
func _ready():
	if destination == null:
		destination = "res://scenes/Portal B.tscn"

func _on_Button_pressed() -> void:
	print("Button pressed!")
	var scene = ResourceLoader.load("res://scenes/game.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene("res://scenes/game.tscn")  # Change this to use the path directly
	else:
		print("Failed to load the scene!")
