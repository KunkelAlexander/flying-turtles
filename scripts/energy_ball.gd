extends Area2D

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the sprite
@export var speed: float = 1200.0
@export var lifetime: float = 2.0  # Fireball lifespan in seconds
@onready var collision_shape = $CollisionShape2D
var direction: Vector2 = Vector2.RIGHT


# --- Setup ---
func _ready():
	animated_sprite.play("burn")
	collision_shape.disabled = false
	
func _physics_process(delta):
	var viewport_size = get_viewport_rect().size
	
	# Move the energy ball
	global_position += direction * speed * delta
	
	
	# Reduce lifetime
	lifetime -= delta
	if lifetime <= 0:
		queue_free()  # Remove the fireball when its lifetime ends
		
	_wrap_position(viewport_size)

func _on_body_entered(body):
	
	if body.is_in_group("Player"):  # Check if the body belongs to the 'Player' group
		body._enter_state(body.State.CRASHED)
		
	collision_shape.disabled = true
	
	# Remove the energy ball upon collision
	queue_free()
	
	pass



# --- Helper Functions ---
func _wrap_position(viewport_size):
	if position.x > viewport_size.x:
		position.x = 0
	elif position.x < 0:
		position.x = viewport_size.x
