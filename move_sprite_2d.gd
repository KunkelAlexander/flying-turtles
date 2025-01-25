extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the sprite
@onready var crash_label: Label = $"../CrashLabel"
@onready var start_position   = $AnimatedSprite2D/start_position.global_position

# Rocket parameters
var speed = 400.0            # forward (upward) speed when under control
var rotation_speed = 90.0    # degrees per second
var gravity = 400.0          # downward acceleration
var walking_speed = 200.0    # Speed when walking


# Boundaries
var top_boundary = -50

# Game States
enum State { CONTROLLED, FALLING, CRASHED, WALKING }
var state = State.WALKING    # Start in the walking state

# Free-fall timer
var free_fall_duration = 2.8
var free_fall_timer = 0.0
var max_landing_angle = 15   # Maximum angle to safely land (in degrees)


# --- Setup ---
func _ready():
	# Initialize position and crash label
	_initialize_position()
	_initialize_crash_label()


func _initialize_position():
	position = start_position
	velocity = Vector2.ZERO
	rotation_degrees = 0  # Reset to upright orientation

	animated_sprite.play("walk")

func _initialize_crash_label():
	crash_label.visible = false
	crash_label.text = "Rocket crashed.\nPress Enter to restart."


# --- State Transitions ---
func _enter_state(new_state):
	state = new_state
	match state:
		State.CONTROLLED:
			free_fall_timer = 0.0
			velocity = Vector2.ZERO
			animated_sprite.play("fly")
		State.FALLING:
			free_fall_timer = 0.0  # Reset the free-fall timer
			animated_sprite.play("hide")
		State.CRASHED:
			velocity = Vector2.ZERO
			crash_label.visible = true
		State.WALKING:
			velocity = Vector2.ZERO
			rotation_degrees = 0  # Reset to rightward orientation
			animated_sprite.play("walk")



# --- Input Handling ---
func _process_input(delta):
	if state == State.CONTROLLED:
		if Input.is_action_pressed("ui_up"):
			rotation_degrees -= rotation_speed * delta
		elif Input.is_action_pressed("ui_down"):
			rotation_degrees += rotation_speed * delta
	elif state == State.WALKING:
		if Input.is_action_just_pressed("ui_up"):
			# Lift off
			_enter_state(State.CONTROLLED)

# --- Physics/Movement ---
func _update_physics(delta):
	var viewport_size = get_viewport_rect().size

		
	match state:
		State.CONTROLLED:
			_process_input(delta)
			var forward_dir = Vector2.RIGHT.rotated(rotation)
			velocity = forward_dir * speed
			move_and_slide()

			if position.y < top_boundary:
				_enter_state(State.FALLING)

			if position.y > start_position.y:
				if abs(int(rotation_degrees) % 180) < max_landing_angle:
					_enter_state(State.WALKING)  # Land safely
				else:
					_enter_state(State.CRASHED)
				
		State.WALKING:
			_process_input(delta)
			# Prevent the rocket from leaving the ground
			position.y = start_position.y
			var forward_dir = Vector2.RIGHT.rotated(rotation)
			velocity = walking_speed * forward_dir
			move_and_slide()

			
			
		State.FALLING:
			free_fall_timer += delta
			velocity.y += gravity * delta
			move_and_slide()


			if position.y > start_position.y:
				_enter_state(State.CRASHED)
			if free_fall_timer >= free_fall_duration:
				_enter_state(State.CONTROLLED)

		State.CRASHED:
			# Wait for restart input
			if Input.is_action_just_pressed("ui_accept"):
				_restart_rocket()

		
	_wrap_position(viewport_size)


# --- Helper Functions ---
func _wrap_position(viewport_size):
	if position.x > viewport_size.x:
		position.x = 0
	elif position.x < 0:
		position.x = viewport_size.x


# --- Reset/Restart ---
func _restart_rocket():
	_initialize_position()
	crash_label.visible = false
	_enter_state(State.WALKING)


# --- Main Process ---
func _process(delta):
	_update_physics(delta)
