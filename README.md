# FoxyAdventure

FoxyAdventure is a 2D pixel-art platformer built in Godot. Play as a fox and explore levels connected by portals. Double-jump, wall-jump, and dash past hazards, fight enemies, and collect coins and keys. Use keys to open treasure chests.

Team 02 built the game in two weeks during a game development program that VNG organized and taught for our university department.

## Run locally

1. Clone the repository.

   ```bash
   git clone https://github.com/baotrinh9707-coder/Project_Team02.git
   ```

2. In Godot 4.6, import the root [`project.godot`](project.godot) file and wait for the assets to finish importing.
3. Open [`scenes/Level1.tscn`](scenes/Level1.tscn) and select **Run Current Scene** to start from Level 1.

## Controls

| Action | Keys |
| --- | --- |
| Move | `A` / `D` or `←` / `→` |
| Jump or double-jump | `Space`, `W`, or `↑` |
| Dash | `Ctrl` |
| Attack | `C` |
| Interact with doors, chests, and portals | `E` |

## Project structure

- [`scenes/`](scenes/) contains the three level scenes, the player, enemies, and collectibles.
- [`scripts/`](scripts/) contains GDScript for player movement, inventory, audio, and game state.
- [`assets/`](assets/) contains art, animations, and audio resources.
