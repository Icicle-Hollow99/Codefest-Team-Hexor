extends CharacterBody2D

const SPEED = 150
const JUMP_VELOCITY = -300
const DASH_SPEED = 500  # Speed during the dash
const DASH_DURATION = 0.2  # Duration of the dash in seconds
const DASH_COOLDOWN = 1.0  # Cooldown before the dash can be used again
const MAX_JUMPS = 2  # Allow double jump
const UP_DASH = 200
const DASH_SPEED_HORIZONTAL = 500  # Speed for left/right dash
const DASH_SPEED_UPWARD = 300  # Slower speed for upward dash
const INVINCIBILITY_DURATION = 0.005  # Duration of invincibility

# Updated collision layers based on your input
const INVINCIBLE_LAYER = 1 << 2  # Layer 3 (index 2)
const NORMAL_LAYER = 1 << 1  # Layer 2 (index 1)

var is_dashing: bool = false  # Tracks if the player is dashing
var dash_timer: float = 0.0  # Timer to handle dash duration
var dash_cooldown_timer: float = 0.0  # Timer to handle dash cooldown
var jump_count: int = 0  # Tracks the number of jumps used
var animated_sprite: AnimatedSprite2D  # Reference to the AnimatedSprite2D node
var original_hitbox_size: Vector2 = Vector2(12, 14.5)  # Store original hitbox size
var dash_hitbox_size: Vector2 = Vector2(10, 10)  # Smaller hitbox size during dash
var is_invincible: bool = false  # Tracks if the player is invincible
var invincibility_timer: float = 0.0  # Timer for invincibility

func _ready():
	animated_sprite = $AnimatedSprite2D  # Update path if necessary

	if animated_sprite == null:
		print("AnimatedSprite2D not found!")

	var shape = $CollisionShape2D.shape as RectangleShape2D
	if shape:
		original_hitbox_size = shape.size
		print("Original hitbox size at start:", original_hitbox_size)
		shape.size = original_hitbox_size  # Ensure correct initial size

func _physics_process(delta: float) -> void:
	if is_invincible:
		invincibility_timer -= delta
		print("Invincibility active. Remaining time:", invincibility_timer)
		if invincibility_timer <= 0:
			end_invincibility()

	if not is_dashing and not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("move_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jump_count += 1

	if is_on_floor():
		jump_count = 0

	dash_cooldown_timer -= delta
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
		start_dash()

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()

	if not is_dashing:
		var direction := Input.get_axis("move_left", "move_right")
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func start_dash():
	is_dashing = true
	set_invincible()
	var shape = $CollisionShape2D.shape as RectangleShape2D
	if shape:
		print("Before dash - hitbox size:", shape.size)
		shape.size = dash_hitbox_size  # Shrink hitbox
		print("Dashing started. New hitbox size:", shape.size)

	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN

	var input_x = Input.get_axis("move_left", "move_right")
	var input_y = Input.get_axis("move_up", "move_down")
	var dash_direction = Vector2(input_x, input_y).normalized()

	if dash_direction == Vector2.UP:
		velocity = dash_direction * DASH_SPEED_UPWARD
	elif dash_direction.x != 0:
		velocity = dash_direction * DASH_SPEED_HORIZONTAL
	else:
		velocity = Vector2.RIGHT * DASH_SPEED_HORIZONTAL

	if animated_sprite != null:
		animated_sprite.animation = "dash"
		animated_sprite.play()

	print("Dash started. Invincible:", is_invincible)

func end_dash():
	is_dashing = false
	var shape = $CollisionShape2D.shape as RectangleShape2D
	if shape:
		print("Before restoring - hitbox size:", shape.size)
		shape.size = original_hitbox_size  # Restore hitbox size
		print("Dashing ended. Restored hitbox size:", shape.size)

	if animated_sprite != null:
		if is_on_floor():
			animated_sprite.animation = "default"
		else:
			animated_sprite.animation = "default"
		animated_sprite.stop()
		animated_sprite.play()

# Set the player to be invincible by changing the collision layer
func set_invincible():
	is_invincible = true
	invincibility_timer = INVINCIBILITY_DURATION
	set_collision_layer(INVINCIBLE_LAYER)
	print("Invincibility started")

# End invincibility and restore normal collision layer
func end_invincibility():
	is_invincible = false
	set_collision_layer(NORMAL_LAYER)
	print("Invincibility ended")
