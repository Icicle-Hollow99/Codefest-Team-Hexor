extends CharacterBody2D

const SPEED = 150
const JUMP_VELOCITY = -400
const FLY_SPEED = 125 # Speed while flying
var is_flying: bool = false # State variable to track if the player is flying

var checkpoint_position: Vector2 = Vector2() # To store the last checkpoint's position

func _ready() -> void:
	# Set the initial checkpoint to the player's starting position
	checkpoint_position = global_position

func _physics_process(delta: float) -> void:
	# Handle gravity when not flying
	if not is_flying and not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump
	if Input.is_action_just_pressed("move_up") and (is_on_floor() or is_flying):
		velocity.y = JUMP_VELOCITY
	
	# Toggle fly mode with input command "fly"
	if Input.is_action_just_pressed("fly"):
		is_flying = !is_flying
		
		# If switching to fly mode, reset vertical velocity for smooth transition
		if is_flying:
			velocity.y = 0
		
		print("Fly toggled: ", is_flying)

	# Handle horizontal movement input
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle vertical movement while flying (up/down)
	if is_flying:
		var fly_direction := Input.get_axis("move_up", "move_down")
		
		if fly_direction != 0:
			velocity.y += fly_direction * FLY_SPEED * delta
		else:
			velocity.y *= 0.95  # Reduce Y speed for smooth stopping
		
		velocity.y = clamp(velocity.y, -FLY_SPEED * 2, FLY_SPEED)

	# Respawn if the player "dies" (e.g., falls below a certain point)
	if global_position.y > 1000:  # Example condition: falling below Y=1000
		respawn()

	# Apply movement (horizontal + vertical)
	move_and_slide()

func respawn() -> void:
	print("Respawning at checkpoint: ", checkpoint_position)
	global_position = checkpoint_position
	velocity = Vector2()  # Reset velocity when respawning

func set_checkpoint(position: Vector2) -> void:
	checkpoint_position = position
	print("Checkpoint set at: ", position)
