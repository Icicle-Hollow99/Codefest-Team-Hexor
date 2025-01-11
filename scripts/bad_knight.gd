extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FLY_SPEED = 150.0 # Speed while flying
var is_flying: bool = false # State variable to track if the player is flying

func _physics_process(delta: float) -> void:
	# Handle gravity when not flying
	if not is_flying and not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("move_up") and (is_on_floor() or is_flying):
		velocity.y = JUMP_VELOCITY
	
	# Toggle fly mode with input command "fly"
	if Input.is_action_just_pressed("fly"):
		is_flying = !is_flying
		
		# If switching to fly mode, reset vertical velocity for smooth transition.
		if is_flying:
			velocity.y = 0
		# Debugging output: This will print every time the "fly" button is pressed.
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
		
		# Adjust vertical speed based on fly controls; use FLY_SPEED for control sensitivity.
		if fly_direction != 0:
			velocity.y += fly_direction * FLY_SPEED * delta
		
		# Reset Y speed so it doesn't affect falling when transitioning out of flight mode  
		else:
			velocity.y *= 0.95
		
		# Prevent excessive upward acceleration (you can tweak this value)
		velocity.y = clamp(velocity.y, -FLY_SPEED * 2, FLY_SPEED)

	# Apply movement (horizontal + vertical)
	move_and_slide()
