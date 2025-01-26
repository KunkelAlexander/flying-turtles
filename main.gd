extends Node

@onready var main_menu = $MainMenu
@onready var player1 = $Player1
@onready var player2 = $Player2
@onready var environment = $Environment

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		_reset_game()

func _reset_game():
	print("Resetting game and showing main menu...")

	Global.game_started = false 
	
	# Reset player states
	player1._reset_state()
	player2._reset_state()

	# Reset environment if needed
	#environment.reset_environment()

	# Show the main menu
	main_menu.visible = true
