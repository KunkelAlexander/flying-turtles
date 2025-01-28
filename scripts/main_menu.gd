extends CanvasLayer

@onready var dots_label = $"Enter2Start-Dot"  # Replace with the actual path to your label node

var blink_time = 1.0  # Time interval for blinking
var blink_timer = 0.0  # Accumulator for timing

var game_started = false  # Tracks if the game has started

func _ready():
	visible = true  # Overlay is visible initially

func _process(delta):
	# Accumulate time
	blink_timer += delta

	# Toggle visibility when the timer exceeds the blink interval
	if blink_timer >= blink_time:
		dots_label.visible = not dots_label.visible
		blink_timer = 0.0  # Reset the timer
		

func _input(event):			
	if not Global.game_started:  # Access the global variable
		if event.is_action_pressed("ui_accept"):  # Start the game
			_start_game()

		# Prevent input from propagating
		return

func _start_game():
	Global.game_started = true  # Update the global variable
	visible = false  # Hide the overlay
	print("Game started!")
