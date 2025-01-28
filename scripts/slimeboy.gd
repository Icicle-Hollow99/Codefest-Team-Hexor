extends Node2D

const SPEED = 60

var direction = -1

@onready var ray_castleft: RayCast2D = $RayCastleft
@onready var ray_castright: RayCast2D = $RayCastright
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# When the player character enters the enemy's hitbox
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		# Debugging: Print the invincibility status when the player collides with the enemy
		print("Player's invincibility status in enemy:", body.is_invincible)
		
		# Only deal damage if the player is not invincible
		if not body.is_invincible:
			# Deal damage (you can handle this in the player class)
			print("Player entered and is not invincible")
			# Do damage logic here (e.g. body.take_damage() or any other effect)
		else:
			print("Player is invincible, no damage dealt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_castright.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false  # Flip the sprite when changing direction
	if ray_castleft.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true  # Flip the sprite when changing direction
	
	# Move the enemy left or right depending on the direction
	position.x += direction * SPEED * delta
