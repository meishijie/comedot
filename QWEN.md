# Comedot - Component-Based Framework for Godot

## Project Overview

Comedot is a component-based framework and project template for the Godot game engine, designed to be an all-in-one toolkit for 2D games (platformers, shoot-em-ups, RPGs, turn-based, tile-based, strategy, puzzle). The framework provides a composition-based architecture where gameplay is built by adding components to entities and tweaking their parameters in the UI.

### Key Features

- **Component System**: Entities contain child components that provide specific behaviors and gameplay functionality
- **Pre-built Components**: Megatons of components for player movement, combat, collectibles, interactions, upgrades, etc.
- **UI Controls**: Stats HUD, dynamic buttons for special skills, inventory systems, etc.
- **Template Scenes**: Pre-built scenes for Logo → Main Menu → Options, Input Remapping, Pause Overlay
- **Save/Load System**: Player preferences saved via config file with simple syntax like `Settings.anyName = 69`
- **Helper Functions**: Extensive debugging tools and helper functions
- **VSCode Snippets**: Code snippets included for development environments
- **Free Assets**: Third-party assets included for quick prototyping

### Architecture

The framework follows an entity-component architecture where:
- **Entities** are `Node2D` objects with the `Entity.gd` script attached, serving as containers for components
- **Components** are child nodes with scripts that `extend Component`, providing specific behaviors
- Components communicate with each other through the parent entity's component dictionary

## Building and Running

### Prerequisites
- **Godot 4.5** (required: "Embrace the Future" ✨)

### Setup Instructions
1. Clone this repository (this is a Godot template, so make a local copy of the entire project for each game)
2. Open the project in Godot 4.5
3. The project should run immediately with the default scene

### Basic Usage
1. Create an Entity node (e.g., `CharacterBody2D` with `Entity.gd` script)
2. Drag components from `/Components/` folders as child nodes
3. Modify component parameters in the Inspector
4. Save the entity+components subtree as a standalone scene

The project includes a custom dock plugin (Comedock) for easier component management.

### Development Commands
- Standard Godot project workflow applies
- The project uses autoload scripts for global functionality
- Scene transitions are handled by the `SceneManager` autoload

### Launch Flow
1. **Initial Scene**: `Scenes/Launch/Logo/IOLogoScene.tscn` - Shows the Comedot logo animation
2. **Main Menu**: `Scenes/Launch/GameFrame.tscn` - Main menu with START, OPTIONS, and QUIT buttons
3. **Game Scene**: When START is clicked, it loads `Templates/Scenes/PlatformerSceneTemplate.tscn` - A complete platformer scene with player, enemies, and UI
4. **Player Setup**: The default player is configured in `Templates/Entities/PlayerEntityTemplate-Platformer.tscn` with platformer controls, health, weapons, etc.

## Development Conventions

### Naming and Code Style
- **No underscores** - uses camelCase exclusively
- **Tabs over spaces** for indentation (2-space tabs)
- **camelCase** for everything, including constants
- **Capitalized names** only for Types
- **Short acronyms** may be fully capitalized (e.g., UINode, HUDColor)

### Function Naming
- Functions should read like verbs: `doSomething()`, `checkValidity()`
- Quick retrieval functions start with `get`: `getComponent(…)`
- Search operations start with `find`: `findComponent(…)`
- Adding existing objects starts with `add`: `addText(…)`
- Creating new objects starts with `create`: `createLabel(…)`

### Signal Naming
- Format: `{object/category}{tense}{event}` (e.g., `healthDidDecrease`)
- Or: `{action}{object}` (e.g., `didSpawnEntity`)
- Or: `{object}{action}` (e.g., `entityDidSpawn`)
- Begin with `did` or `will` where appropriate
- Handler functions named as `on[ObjectThatEmittedSignal]_[signal]`

### Project Structure
- `/Components/` - Various component types (AI, Combat, Control, Physics, etc.)
- `/Entities/` - Entity templates and base class
- `/AutoLoad/` - Global autoload scripts
- `/Assets/` - Game assets (Fonts, Icons, Images, etc.)
- `/Scripts/` - Utility scripts
- `/UI/` - User interface elements
- `/Templates/` - Scene and entity templates
- `/Tests/` - Test scenes for development

### Key Scripts
- `Component.gd` - Base class for all components
- `Entity.gd` - Base class for all entities
- `GlobalInput.gd` - Input handling and shortcuts
- `AutoLoad/*.gd` - Various global systems

## Core Concepts

### Entity Component System
The framework implements an entity-component architecture where:
- **Entities** are game objects that contain only child components
- **Components** provide specific behaviors and can interact with other components in the same entity
- Components have access to `coComponents` dictionary for easy communication with sibling components

### Component Communication
Components in an entity can access each other through the `coComponents` dictionary, which maps component class names to component instances for fast lookup.

### Input System
The project uses Godot's input mapping system with predefined action names for common game functions like movement, jumping, interacting, etc.

### Debugging Tools
The framework includes comprehensive debugging tools and visual indicators, with configurable debug levels for entities and components.

## Important Notes

- This is a personal project still under active development
- No backwards compatibility is guaranteed
- Requires Godot 4.5 for full compatibility
- The API intentionally avoids underscore conventions

## Key Files and Directories

- `project.godot` - Godot project configuration
- `README.md` - Main documentation
- `HowTo.md` - Step-by-step usage guides
- `Conventions.md` - Coding standards and design principles
- `Components/Component.gd` - Base component class
- `Entities/Entity.gd` - Base entity class
- `AutoLoad/*.gd` - Global autoload scripts

## Qwen Added Memories
- 把上述的所有内容都记住
- 记住上述操作手册
- To add more enemies and coins to the Comedot Godot project:
1. Create a new scene by copying an existing template scene (e.g., PlatformerSceneTemplate.tscn)
2. In the new scene file, add additional nodes using the existing resource IDs:
   - For enemies: [node name="MonsterEntityN" parent="." instance=ExtResource("4_a3w4r")] with different positions
   - For collectibles: [node name="CollectibleEntityN" parent="." instance=ExtResource("5_abcde")] with different positions
3. Each entity uses the component-based architecture with the same component set as the original
4. The resource IDs for the templates are: enemies=ExtResource("4_a3w4r"), collectibles=ExtResource("5_abcde"), player=ExtResource("4_an8j4")
