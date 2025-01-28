extends Control

var awaiting_input = false  # Tracks if a button is awaiting key input
var action_to_rebind = ""   # The action being rebound
var button_to_update = null # Reference to the button being updated

func _ready():
	print("Setting up button signals!")
	# Connect button signals
	$UpP1.pressed.connect(_on_button_pressed.bind("p1_down", $UpP1))
	$DownP1.pressed.connect(_on_button_pressed.bind("p1_down", $DownP1))
	$ShootP1.pressed.connect(_on_button_pressed.bind("p1_shoot", $ShootP1))

	$UpP2.pressed.connect(_on_button_pressed.bind("p2_up", $UpP2))
	$DownP2.pressed.connect(_on_button_pressed.bind("p2_down", $DownP2))
	$ShootP2.pressed.connect(_on_button_pressed.bind("p2_shoot", $ShootP2))


	# Update button labels with current key bindings
	_update_buttons()

	
func _on_button_pressed(action, button):
	if awaiting_input:
		return  # Prevent reassigning multiple keys simultaneously

	awaiting_input = true
	action_to_rebind = action
	button_to_update = button
	button.text = "Press any key..."  # Temporary feedback

func _input(event):
	if awaiting_input and event is InputEventKey and event.pressed:
		# Assign the new key to the selected action
		InputMap.action_erase_events(action_to_rebind)  # Clear existing bindings
		InputMap.action_add_event(action_to_rebind, event)  # Add the new binding

		# Update the button text with the new key
		button_to_update.text = action_to_rebind.capitalize() + ": " + OS.get_keycode_string(event.keycode)

		# Reset state
		awaiting_input = false
		action_to_rebind = ""
		button_to_update = null

		# Update all buttons to reflect the change
		_update_buttons()

func _update_buttons():
	# Update Player 1 buttons
	$UpP1.text = "Up: " + _get_binding("p1_up")
	$DownP1.text = "Down: " + _get_binding("p1_down")
	$ShootP1.text = "Shoot: " + _get_binding("p1_shoot")

	# Update Player 2 buttons
	$UpP2.text = "Up: " + _get_binding("p2_up")
	$DownP2.text = "Down: " + _get_binding("p2_down")
	$ShootP2.text = "Shoot: " + _get_binding("p2_shoot")
	
func _get_binding(action):
	var events = InputMap.action_get_events(action)
	print("Events for ", action, ":", events)  # Debugging output
	for event in events:
		if event is InputEventKey:
			# CAREFUL:: When physical = true, keycode is shown when printing event, but even.keycode is zero when accessed directly
			# Use physical_keycode instead
			# print("Event debug:", event)  # Shows full InputEventKey details
			# print("Event keycode:", event.keycode)  # Check keycode access
			# print("Event keycode:", event.physical_keycode)  # Check keycode access
			return OS.get_keycode_string(event.physical_keycode)  # Retrieve the key's string representation
	return "Unbound"
