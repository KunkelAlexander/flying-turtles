extends Node

# Reference to the Label node
@onready var debug_label = $CanvasLayer/Label

# Key variables to debug
var rocket_position: Vector2

func _process(delta):
	# Update key variables (for demonstration purposes)
	rocket_position = $CharacterBody2D.global_position

	# Update the debug label's text
	debug_label.text = """
	Debug Info:
	Position: %s
	""".strip_edges() % [rocket_position]
