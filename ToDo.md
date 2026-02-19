# ToDo 

NOTE: That file is NOT regularly updated, so search the source code for `TODO:` or `FIXME:` etc. comments to see exactly what's missing and where.


## 🔴 Urgent - Fixes Needed (Skills: combat-system, bug-fix, physics)

- [ ] **GunComponent Refactor** - Decouple from `InputComponent`. Currently, `TurretEntity` requires a dummy `InputComponent` (with `isPlayerControlled = false`) just to satisfy `GunComponent`'s dependency. `GunComponent` should support AI control more natively.
  - _Related Skills_: `combat-system`, `ai-behavior`, `bug-fix`
- [ ] **Camera Jitter Fix** - Occurs when reattaching (mentioned in analysis).
  - _Related Skills_: `bug-fix`, `physics`
- [ ] **GunComponent Velocity Bug** - Shooting while moving backwards makes bullets faster.
  - _Related Skills_: `combat-system`, `bug-fix`, `physics`


## 🟡 Major Features (By Domain)

### State & Persistence
- [ ] **Game State Architecture** - Standard architecture for game environment state and "current run/campaign" state
  - _Related Skills_: `comedot-core`, `turn-based`
- [ ] **Save/Load System** - Player progress, settings, game state persistence
  - _Related Skills_: `comedot-core`, `turn-based`

### UI System (Skill: comedot-ui)
- [ ] **Standard UI Architecture** - For in-game menus and windows etc.
  - _Related Skills_: `comedot-ui`
- [ ] **Pause Menu** - Complete pause overlay with options
  - _Related Skills_: `comedot-ui`
- [ ] **Settings UI** - Graphics, audio, control settings interface
  - _Related Skills_: `comedot-ui`

### Audio System (Skill: comedot-audio)
- [ ] **Audio Management Architecture** - Global audio control and mixing
  - _Related Skills_: `comedot-audio`
- [ ] **Volume Controls Integration** - BusVolumeUI connection with GlobalSonic
  - _Related Skills_: `comedot-audio`, `comedot-ui`

### Turn-Based System (Skill: turn-based)
- [ ] **Turn-Based Save/Load** - Save turn state, counters, action points
  - _Related Skills_: `turn-based`, `comedot-core`
- [ ] **Turn-Based UI Architecture** - Better integration with UI system
  - _Related Skills_: `turn-based`, `comedot-ui`
- [ ] **Speed Calculation Optimization** - Turn order performance
  - _Related Skills_: `turn-based`


## Maybe

- [ ] Convert `str()` calls to Format Strings (or string interpolation if possible)
- [ ] ? Add `avoidGroups` parameter for node spawning functions


## Done

- [x] Pathfinding/Navigation Components
- [x] Player Settings
- [x] Random populating Area2D
- [x] Add `groups` parameter for node spawning functions
- [x] Add debugging breakpoint shortcut input

---

## 🤖 Agent Skills Reference

### Available Skills (`.factory/droids/`)

| Skill | Domain | Current Focus |
|-------|--------|---------------|
| `godot-developer` | General Godot Dev | 11 tools for scene/node management |
| `combat-system` | Combat | GunComponent refactor, velocity bug |
| `ai-behavior` | AI | Turret AI, target prediction |
| `turn-based` | Turn-Based | Save/load, UI architecture |
| `bug-fix` | Bug Fixes | Camera jitter, GunComponent issues |
| `testing` | Testing & Debug | Run tests, DebugComponent |
| `ui-development` | UI System | Menu architecture, windows |
| `physics` | Physics | Collision, CharacterBody optimization |
| `audio` | Audio | GlobalSonic, volume controls |
| `comedot-core` | Core Logic | Entity-Component system |

### Quick Task-to-Skill Mapping

| Task Type | Use Skill |
|-----------|-----------|
| Gun/Health/Damage components | `combat-system` |
| Turret/Chase/Navigation AI | `ai-behavior` |
| Turn order/Counters | `turn-based` |
| Menus/Buttons/Lists/Charts | `ui-development` |
| Collision/Physics/Body | `physics` |
| Audio/Music/Sound | `audio` |
| Running tests/Debug output | `testing` |
| Bug fixes/Critical fixes | `bug-fix` |
| General Godot operations | `godot-developer` |
