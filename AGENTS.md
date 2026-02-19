# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Comedot is a component-based framework and project template for Godot 4.5+, designed for 2D games (platformers, shoot-em-ups, RPGs, turn-based, tile-based, strategy, puzzle). It uses composition over inheritance through an Entity-Component architecture.

## Development Commands

### Running the Project
- Open in **Godot 4.5** (required version)
- Press F5 or click Play to run the main scene
- Default launch sequence: Logo → Main Menu → Game Scene

### Testing Individual Components
- Navigate to `/Tests/` directory for component test scenes
- Common test scenes:
  - `Tests/Combat/` - Combat system tests
  - `Tests/TurnBased/TurnBasedTest.tscn` - Turn-based gameplay
  - `Tests/Upgrades/UpgradeTest.tscn` - Upgrade system
  - `Tests/InteractionTest.tscn` - Interaction components

### Debugging Tools
- Enable `debugMode` on Components and Entities for verbose logging
- Use `Debug.printTrace()`, `Debug.printHighlight()` for debugging
- Real-time variable monitoring with `DebugComponent`, `ChartWindow`, `Chart`
- Example: Monitor velocity with `../CharacterBodyComponent:body:velocity:x`

## Execution Flow & Scene Configuration

### Startup Sequence
1. **Boot**: `project.godot` loads `Scenes/Launch/Logo/IOLogoScene.tscn` (uid://7hpq16neqhai).
2. **Initialization**: `IOLogoScene.gd` (extends `Start.gd`) initializes the framework (`setupGameState()`).
3. **Menu**: Transitions to `Scenes/Launch/GameFrame.tscn` (Main Menu container).
4. **Gameplay**: Clicking "Start" triggers `GameState.startMainScene()`, loading the scene defined in `Settings.mainGameScenePath`.

### Configuring the Game Scene
To change which level/scene loads when the player clicks "Start":
1. Open `Scenes/Launch/Logo/IOLogoScene.tscn`.
2. Select the root node `IOLogoScene`.
3. In the Inspector, find the exported variable **Main Game Scene Path**.
4. Set it to the path/UID of your desired game scene (e.g., `Scenes/GameSceneWithMore.tscn`).
   - This value is registered to `Settings.mainGameScenePath` during the logo sequence.

## Architecture Overview

### Core Entity-Component System
- **Entities** (`Entity.gd`): Game objects that serve as component containers
  - Must be Node2D descendants with `Entity.gd` script
  - Manage component registration via `components` Dictionary
  - Key properties: `sprite`, `area`, `body` for primary node references
  - Lifecycle: `NOTIFICATION_PARENTED` → `_enter_tree()` → `_ready()`

- **Components** (`Component.gd`): Reusable behaviors extending `Component`
  - Access sibling components via `coComponents` Dictionary  
  - Use `coComponents.ComponentClassName` or `coComponents.get(&"ComponentClassName")`
  - Must implement `getRequiredComponents()` for dependencies
  - Register with parent Entity automatically via `_enter_tree()` and a retry in `_ready()`
  - **IMPORTANT**: If overriding `_ready()`, you MUST call `super._ready()` to ensure the registration retry logic executes.

### Global AutoLoad System
9 critical autoload scripts provide framework functionality:
- `Global.gd` - Framework constants, Groups, utilities
- `GameState.gd` - Game state management, player data, global events
- `SceneManager.gd` - Scene loading, transitions (`loadSceneAndAddInstance()`, `transitionToScene()`)
- `GlobalInput.gd` - Input action management
- `Settings.gd` - Player preferences, config file I/O
- `TurnBasedCoordinator.gd` - Turn-based game coordination
- `Debug.gd` - Logging system (`printLog()`, `printWarning()`, `printError()`)
- `GlobalUI.tscn` - Global UI layer (pause overlay)
- `GlobalSonic.tscn` - Audio management

### Component Categories
- `/Components/Combat/` (15 components) - Health, damage, factions
- `/Components/Movement/` (18 components) - Physics, platformer, overhead movement
- `/Components/Control/` - Player input, AI behavior
- `/Components/AI/` - AI decision making
- `/Components/Interaction/` - Object interactions, collectibles
- `/Components/Physics/` - CharacterBody integration
- `/Components/TurnBased/` - Turn-based game components
- `/Components/Visual/` - Visual effects, animations

### Key Utilities
- `Tools.gd` (1431 lines) - Core utility functions for Godot limitations
- `Entities/Entity.gd` (~700 lines) - Entity base class with component management
- `Components/Component.gd` - Component base class with Entity integration

## Development Workflow

### Creating New Entities
1. Create `CharacterBody2D`/`Node2D` with `Entity.gd` script
2. Add Components as child nodes using "Instantiate Child Scene" (Shift+Ctrl/Cmd+A)
3. Use `.tscn` files, NOT `.gd` script files
4. Set collision layers: `players`, `enemies`, `terrain` in Physics settings
5. Save entity+components as standalone scene in `/Entities/` or `/Templates/Entities/`

### Creating New Components
1. Create scene in appropriate `/Components/` subfolder
2. Root node type: `Node2D` for visuals, `Node` for logic-only
3. Add root to `components` group, enable "Group Selected Nodes"
4. Attach script extending `Component`
5. Implement `getRequiredComponents()` for dependencies
6. Access siblings via `coComponents.ComponentName` or `parentEntity.getComponent()`

### Component Communication Patterns
```gdscript
# Accessing sibling components
var healthComponent = coComponents.get(&"HealthComponent")
var damageComp = parentEntity.getComponent(&"DamageComponent")

# Required component dependencies
func getRequiredComponents() -> Array[Script]:
    return [HealthComponent, CollisionShape2D]
```

### Turn-Based Development
1. Enable `TurnBasedCoordinator` autoload
2. Use `TurnBasedEntity` instead of `Entity`
3. Components extend `TurnBasedComponent`
4. Implement: `processTurnBegin()`, `processTurnUpdate()`, `processTurnEnd()`
5. Connect UI to `TurnBasedCoordinator.startTurnProcess()`

## Code Conventions

**Critical Style Rules:**
- **NO underscores** - use `camelCase` for everything
- **Tabs over spaces** (2-space width)
- **camelCase** for variables, functions, constants
- **PascalCase** for Types/Classes only
- Function names as verbs: `doSomething()`, `checkValidity()`
- `get` prefix for quick retrieval: `getComponent()`
- `find` prefix for searches: `findComponent()`
- `create` prefix for instantiation: `createLabel()`

**Signal Naming:**
- Format: `{object}{tense}{event}` (e.g., `healthDidDecrease`)
- Use `did`/`will` prefixes where appropriate
- Handlers: `on[ObjectName]_[signalName]` or `on[SignalName]`

## File Organization

### Template Usage
- `/Templates/Entities/` - Pre-built entity templates
- `/Templates/Scenes/` - Complete scene templates
- `/Templates/Examples/` - Component usage examples

### Asset Structure  
- `/Assets/Icons/` - Component and entity icons
- `/Assets/Fonts/` - PixelOperator8.ttf (main font)
- `/Assets/Themes/` - UI themes
- `/Assets/Tiles/` - Tileset resources

## Common Issues & Solutions

### AreaCollisionComponent Signals
- `AreaCollisionComponent` (and its subclasses like `BounceComponent`) does **NOT** connect collision signals (`body_entered`, etc.) by default.
- **Solution**: You MUST call `connectSignals()` manually in your subclass's `_ready()` method, OR set `shouldConnectSignalsOnReady = true` in the inspector (or default value).
- Failure to do this will result in no collision callbacks being triggered.

### Component Dependencies
- Order matters in entity node tree - check component requirements
- Missing dependencies cause crashes - implement `getRequiredComponents()`
- Use `checkRequiredComponents()` for validation
- **InputComponent Dependency**: `GunComponent` currently has a hard dependency on `InputComponent`. If using `GunComponent` on an AI entity (like a Turret), you must add an `InputComponent` and set `isPlayerControlled = false`.
- **Component Registration Retry**: If a component reports "No parentEntity", it likely initialized before its parent in the scene loading order. `Component.gd` includes a retry in `_ready()`. Ensure your subclass calls `super._ready()`.
- **Flexible Weapon Interfaces**: `TurretBehaviorComponent` supports both `GunComponent` and `DamageRayComponent`. It uses `has_method(&"fire")` for guns and toggles `isEnabled` for ray-based weapons.

### Performance Considerations
- `functionsAlreadyCalledOnceThisFrame` prevents duplicate frame calls
- `CharacterBodyComponent` must be LAST child for physics components
- Disable `debugMode` and logging in production builds

### Game Initialization
- Main scene MUST have `/Scripts/Start.gd` script on root node
- Initializes Comedot framework and global flags
- Required before other scripts run

## Project Structure Notes

- This is a **template project** - clone entire folder for each game
- **No backward compatibility** guaranteed - active development
- Use git branches for different games within same template
- Place game-specific content in `/Game/` subfolder to avoid framework conflicts
