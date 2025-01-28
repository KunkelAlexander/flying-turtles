extends Node

@onready var main_menu = $MainMenu
@onready var player1 = $Player1
@onready var player2 = $Player2
@onready var environment = $Environment

@onready var score_label = $Environment/ScoreLabel
@onready var winner_screen = $Environment/WinnerScreen
@onready var winner_label = $Environment/WinnerScreen/WinnerLabel

var score = { "player1": 0, "player2": 0 }
var max_score = 10
var game_active = true


func _ready():
	_reset_game()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		if Global.game_started: 
			_reset_game()
		else:
			_reset_game()
	elif event.is_action_pressed("ui_accept") and not game_active:  # Enter to restart
		_reset_game()

func update_score(player_crashed: String):
	if game_active:
		if player_crashed == "player1":
			score["player2"] += 1
		elif player_crashed == "player2":
			score["player1"] += 1
		
		_update_score_display()
		_check_winner()
		

func _check_winner():
	if score["player1"] >= max_score:
		game_active = false
		winner_label.text = "P1 wins!\nPress Enter."
		winner_screen.visible = true
	elif score["player2"] >= max_score:
		game_active = false
		winner_label.text = "P2 wins!\nPress Enter."
		winner_screen.visible = true


func _reset_game():
	print("Resetting game and showing main menu...")

	# Reset game state
	score = { "player1": 0, "player2": 0 }
	game_active = true


	Global.game_started = false 
	
	# Reset player states
	player1._reset_state()
	player2._reset_state()

	# Reset labels
	score_label.text = "0:0"
	winner_screen.visible = false

	# Show the main menu
	main_menu.visible = true

func _update_score_display():
	# Update the score label text
	score_label.text = str(score["player1"]) + ":" + str(score["player2"])
