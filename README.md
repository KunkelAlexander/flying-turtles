
# 2D Multiplayer Rocket Game

Welcome to the **2D Multiplayer Rocket Game**! [Play it here](https://kunkelalexander.github.io/flying-turtles/). This project is a simple, fast-paced, and hopefully at least a little fun 2-player game where players control rockets, dodge obstacles, and compete to score points by outmaneuvering each other. Built using the [Godot Engine](https://godotengine.org/).

![](scene.gif)
---

## Features

- **2-Player Gameplay**:
  - Each player controls their rocket using configurable controls.
  - Players can shoot energy balls and move strategically to avoid crashing.

- **Customizable Controls**:
  - Rebind keys for each player dynamically through the main menu.

- **Score Tracking and Victory Screen**:
  - The first player to reach the maximum score wins the game!
  - A winner screen displays the results, allowing easy resets.

- **Dynamic Physics**:
  - Gravity, rotation, and speed are key gameplay elements.
  - Rockets can walk, fly, or crash, depending on their state.

- **Clean UI**:
  - Main menu for starting the game and setting controls.
  - In-game score display and crash notifications.

- **State Management**:
  - Each rocket has distinct states: Walking, Flying, Falling, and Crashed.

---

## Project Structure

### Directory Overview
```plaintext
├── scenes/            # All game scenes
│   ├── main.tscn      # The main game scene + menu
│   ├── player.tscn     # The player rocket scenes
│   └── energy_ball.tscn # Energy ball
├── scripts/           # All game scripts
├── assets/            # Assets for the game
│   ├── sprites/        # Sprites for players, UI, etc.
│   └── fonts/          # Fonts for UI elements
└── README.md          # Project README
```

### Key Scripts

- **`main.gd`**:
  - Manages overall game logic, including scores, reset logic, and state transitions.
- **`player.gd`**:
  - Controls individual player behavior, such as movement, shooting, and physics.
- **`main_menu.gd`**:
  - Handles input rebinding and navigation in the main menu.
---

## Getting Started

### Prerequisites

- [Godot Engine 4.x](https://godotengine.org/download) installed on your machine.
- Basic understanding of how to run a Godot project.

### Running the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/2d-multiplayer-rocket-game.git
   cd 2d-multiplayer-rocket-game
   ```

2. Open the project in Godot:
   - Launch Godot and select the `project.godot` file in the root directory.

3. Play the game:
   - Click the **Play** button in Godot or press `F5`.

---

## How to Play

1. Start the game from the main menu.
2. **Player 1** (Default Controls):
   - Move up: `W`
   - Move down: `S`
   - Shoot: `D`
3. **Player 2** (Default Controls):
   - Move up: `Up Arrow`
   - Move down: `Down Arrow`
   - Shoot: `Right Arrow`
4. Score points by avoiding crashes or outmaneuvering the other player.
5. First to the maximum score wins!

---

## Customization

### Rebinding Keys
- Use the main menu to rebind controls dynamically for each player.
- Simply click on the button, press the desired key, and it will be updated.

### Adjusting Game Rules
- Modify `max_score` in `BaseNode.gd` to change the winning score.
- Tweak physics parameters (e.g., `gravity`, `speed`) in `Player.gd` for custom gameplay.

---

## Contribution

Contributions are welcome! Feel free to:
- Open issues for bugs or feature requests.
- Submit pull requests to enhance the project.

### Suggested Improvements
- Add AI for single-player mode.
- Introduce power-ups and obstacles.
- Enhance visuals and animations.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgments

- Built with the [Godot Engine](https://godotengine.org/).
- Inspired by classic multiplayer arcade games.
- Thanks to all open-source contributors for resources and tutorials!

---

Enjoy the game! 🚀
