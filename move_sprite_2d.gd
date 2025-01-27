extends CharacterBody2D

@onready var base_node = get_parent()  # Reference to the BaseNode

@export var player_number: int = 1  # Player identifier

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the sprite
@onready var crash_label: Label = $"../Environment/CrashLabel"
@onready var score_label: Label = $"../Environment/ScoreLabel"
@onready var start_position   = $AnimatedSprite2D/start_position.global_position
@onready var collision_walk = $CollisionShape_Walk
@onready var collision_fly = $CollisionShape_Fly
@export var energy_ball_scene: PackedScene  # Drag the energy ball scene here
@export var orientation: float = 1

# Define the offset distance for the energy ball
var offset_distance = 50.0

# Rocket parameters
var speed = 400.0            # forward (upward) speed when under control
var rotation_speed = 90.0    # degrees per second
var gravity = 400.0          # downward acceleration
var walking_speed = 200.0    # Speed when walking
var can_shoot = true  # Track if the player can shoot
@export var cooldown: float = 0.3  # Cooldown duration in seconds

# Boundaries
var top_boundary = -50

# Game States
enum State { CONTROLLED, FALLING, CRASHED, WALKING }
var state   # Start in the walking state

# Free-fall timer
var free_fall_duration = 2.8
var free_fall_timer = 0.0
var max_landing_angle = 15   # Maximum angle to safely land (in degrees)

# --- Setup ---
func _ready():
	
	_initialize()
	
func _initialize(): 
	if player_number == 1:
		print("Player 1 initialized!")
	elif player_number == 2:
		print("Player 2 initialized!")
		
	# Initialize position and crash label
	_initialize_position()
	_initialize_crash_label()
	_enter_state(State.WALKING)
	

func _set_collision_shape(animation_name: String):
	# Disable all collision shapes
	collision_walk.disabled = true
	collision_fly.disabled = true

	# Enable the appropriate shape based on the animation
	match animation_name:
		"walk":
			collision_walk.disabled = true
		"fly":
			collision_fly.disabled = false
		"hide":
			collision_walk.disabled = false

func _initialize_position():
	position = start_position
	velocity = Vector2.ZERO

	animated_sprite.play("walk")

func _initialize_crash_label():
	crash_label.visible = false
	
func _initialize_score_label():
	score_label.visible = true
	score_label.text = "0:0"
	
# --- State Transitions ---
func _enter_state(new_state):
	if state == new_state:
		return 
		
	state = new_state
	match state:
		State.CONTROLLED:
			free_fall_timer = 0.0
			velocity = Vector2.ZERO
			animated_sprite.play("fly")
			_set_collision_shape("fly")
		State.FALLING:
			free_fall_timer = 0.0  # Reset the free-fall timer
			animated_sprite.play("hide")
			_set_collision_shape("hide")
		State.CRASHED:
			animated_sprite.play("explode")
			velocity = Vector2.ZERO
			crash_label.visible = true
			crash_label.text = "P%d crashed.\nShoot\nto restart." % [player_number]
			base_node.update_score("player%d" % [player_number])  # Update score when Player 1 crashes

		State.WALKING:
			# Prevent the rocket from leaving the ground
			position.y = start_position.y
			velocity = Vector2.ZERO
			scale=Vector2(orientation, 1)
			rotation_degrees = 0  # Reset to rightward orientation
			
			animated_sprite.play("walk")
			_set_collision_shape("walk")



# --- Input Handling ---
func _process_input(delta):
	if not Global.game_started:  # Access the global variable
		return
		
	if state == State.CONTROLLED:
		if Input.is_action_pressed("p%d_up" % [player_number]):
			rotation_degrees -= rotation_speed * delta * orientation
		elif Input.is_action_pressed("p%d_down" % [player_number]):
			rotation_degrees += rotation_speed * delta * orientation
		if Input.is_action_pressed("p%d_shoot" % [player_number]) and can_shoot:
			shoot_energy_ball()
	elif state == State.WALKING:
		if Input.is_action_just_pressed("p%d_up" % [player_number]):
			# Lift off
			_enter_state(State.CONTROLLED)

				
func shoot_energy_ball():
	# Instance the energy ball
	var energy_ball = energy_ball_scene.instantiate()

	# Rotate the energy ball to match the player's rotation
	energy_ball.rotation = rotation
		
	var offset = Vector2.RIGHT.rotated(rotation) * offset_distance
	
	# Set its position and direction
	energy_ball.global_position = global_position + offset
	energy_ball.direction = Vector2.RIGHT.rotated(rotation)

	# Add the energy ball to the scene
	get_tree().root.add_child(energy_ball)
	
	
	can_shoot = false  # Disable shooting
	await get_tree().create_timer(cooldown).timeout
	can_shoot = true  # Re-enable shooting
	
# --- Physics/Movement ---
func _update_physics(delta):
	var viewport_size = get_viewport_rect().size

		
	match state:
		State.CONTROLLED:
			_process_input(delta)
			var forward_dir = Vector2.RIGHT.rotated(rotation)
			velocity = forward_dir * speed
			move_and_slide()
			
			
			for i in get_slide_collision_count():
				_enter_state(State.CRASHED)

			if position.y < top_boundary:
				_enter_state(State.FALLING)
				
			var safe_landing = true
			var no_takeoff = true
			
			if player_number == 1: 
				no_takeoff   = rotation_degrees > 0
				safe_landing = rotation_degrees < max_landing_angle
			if player_number == 2: 
				no_takeoff   = rotation_degrees > 0
				safe_landing = rotation_degrees > 180 - max_landing_angle and rotation_degrees <= 180

			if position.y > start_position.y - 100 and no_takeoff:
				if safe_landing:
					_enter_state(State.WALKING)  # Land safely
				else:
					_enter_state(State.CRASHED)
				
		State.WALKING:
			_process_input(delta)
			var forward_dir = Vector2.RIGHT.rotated(rotation)
			velocity = walking_speed * forward_dir
			move_and_slide()

			
			
		State.FALLING:
			free_fall_timer += delta
			velocity.y += gravity * delta
			move_and_slide()

			for i in get_slide_collision_count():
				_enter_state(State.CRASHED)
				break

			if free_fall_timer >= free_fall_duration:
				_enter_state(State.CONTROLLED)


		State.CRASHED:
			# Wait for restart input
			if Input.is_action_just_pressed("p%d_shoot" % [player_number]):
				_restart_rocket()
		
	_wrap_position(viewport_size)


# --- Helper Functions ---
func _wrap_position(viewport_size):
	if position.x > viewport_size.x:
		position.x = 0
	elif position.x < 0:
		position.x = viewport_size.x


# --- Reet/Restart ---
func _restart_rocket():
	_initialize()

func _reset_state():
	_initialize()
	
func _on_CollisionShape2D_body_entered(body):
	if body.name.contains("Player"):
		print("Player collided with another player!")
		_enter_state(State.CRASHED)
		
# --- Main Process ---
func _process(delta):
	_update_physics(delta)
