extends Sprite2D

@onready var crash_label: Label = $"../CrashLabel"

# Rocket parameters
var speed = 300.0            # forward (upward) speed when under control
var rotation_speed = 90.0    # degrees per second
var gravity = 400.0          # downward acceleration

# Boundaries
var top_boundary = -50

# Game States
enum State { CONTROLLED, FALLING, CRASHED }
var state = State.CONTROLLED

# Internal state
var velocity = Vector2.ZERO

# Free-fall timer
var free_fall_duration = 2.0
var free_fall_timer = 0.0


# --- Setup ---
func _ready():
	# Initialize position and crash label
	_initialize_position()
	_initialize_crash_label()


func _initialize_position():
	var viewport_size = get_viewport_rect().size
	position = Vector2(viewport_size.x / 2, viewport_size.y - 300)
	velocity = Vector2.ZERO


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
		State.FALLING:
			free_fall_timer = 0.0  # Reset the free-fall timer
		State.CRASHED:
			velocity = Vector2.ZERO
			crash_label.visible = true


# --- Input Handling ---
func _process_input(delta):
	if Input.is_action_pressed("ui_up"):
		rotation_degrees -= rotation_speed * delta
	elif Input.is_action_pressed("ui_down"):
		rotation_degrees += rotation_speed * delta

# --- Physics/Movement ---
func _update_physics(delta):
	var viewport_size = get_viewport_rect().size

		
	match state:
		State.CONTROLLED:
			_process_input(delta)
			var forward_dir = Vector2.UP.rotated(rotation)
			velocity = forward_dir * speed
			position += velocity * delta

			if position.y < top_boundary:
				_enter_state(State.FALLING)

			if position.y > viewport_size.y:
				_enter_state(State.CRASHED)
				
		State.FALLING:
			free_fall_timer += delta
			velocity.y += gravity * delta
			position += velocity * delta

			if free_fall_timer >= free_fall_duration:
				_enter_state(State.CONTROLLED)

		State.CRASHED:
			# Wait for restart input
			if Input.is_action_just_pressed("ui_accept"):
				print("Crashed")
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
	_enter_state(State.CONTROLLED)


# --- Main Process ---
func _process(delta):
	_update_physics(delta)
