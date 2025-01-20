extends CharacterBody2D

const SPEED = 150
const JUMP_VELOCITY = -300
const DASH_SPEED = 500 # Speed during the dash
const DASH_DURATION = 0.2 # Duration of the dash in seconds
const DASH_COOLDOWN = 1.0 # Cooldown before the dash can be used again
const MAX_JUMPS = 2 # Allow double jump

var is_dashing: bool = false # Tracks if the player is dashing
var dash_timer: float = 0.0 # Timer to handle dash duration
var dash_cooldown_timer: float = 0.0 # Timer to handle dash cooldown
var jump_count: int = 0 # Tracks the number of jumps used
var animated_sprite: AnimatedSprite2D # Reference to the AnimatedSprite2D node

func _ready():
	# Get the AnimatedSprite2D node
	animated_sprite = $AnimatedSprite2D  # Update path if necessary

	if animated_sprite == null:
		print("AnimatedSprite2D not found!")

func _physics_process(delta: float) -> void:
	# Handle gravity when not dashing
	if not is_dashing and not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("move_up"):
		if is_on_floor(): # Jump from the ground
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count < MAX_JUMPS: # Perform double jump
			velocity.y = JUMP_VELOCITY
			jump_count += 1

	# Reset jump count when on the floor
	if is_on_floor():
		jump_count = 0

	# Handle dash activation
	dash_cooldown_timer -= delta
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
		start_dash()

	# Handle dash duration
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()

	# Handle horizontal movement if not dashing
	if not is_dashing:
		var direction := Input.get_axis("move_left", "move_right")
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply movement
	move_and_slide()

func start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN
	var input_direction = Input.get_axis("move_left", "move_right")
	velocity.x = DASH_SPEED * (input_direction if input_direction != 0 else 1) # Default to right if no direction pressed
	velocity.y = 0 # Prevent vertical movement during dash

	# Play dash animation
	if animated_sprite != null:
		animated_sprite.animation = "dash"  # Set to the "dash" animation
		animated_sprite.play()  # Start the dash animation

func end_dash():
	is_dashing = false

	# Transition back to the idle/default animation after the dash ends
	if animated_sprite != null:
		# Check if the player is on the floor and transition accordingly
		if is_on_floor():
			animated_sprite.animation = "default"  # Switch to "default" animation (idle)
		else:
			animated_sprite.animation = "default"  # Keep the "default" animation (since no jump animation exists)

		# Explicitly stop the dash animation and transition to default
		animated_sprite.stop()
		animated_sprite.play()  # Ensure the default animation starts playing
