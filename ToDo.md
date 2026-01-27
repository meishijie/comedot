# ToDo 

NOTE: That file is NOT regularly updated, so search the source code for `TODO:` or `FIXME:` etc. comments to see exactly what's missing and where.


## Pending Tasks (Added by Sisyphus)

- [ ] Refactor `GunComponent` to decouple from `InputComponent`. Currently, `TurretEntity` requires a dummy `InputComponent` (with `isPlayerControlled = false`) just to satisfy `GunComponent`'s dependency. `GunComponent` should support AI control more natively.
- [ ] Fix Camera jitter when reattaching (mentioned in analysis).
- [ ] Fix GunComponent velocity bug (shooting while moving backwards makes bullets faster).


## Major

- [ ] Standard architecture for game environment state and "current run/campaign" state
- [ ] Save/Load ...oh my godot
- [ ] Standard UI architecture for in-game menus and windows etc.


## Maybe

- [ ] Convert `str()` calls to Format Strings (or string interpolation if possible)
- [ ] ? Add `avoidGroups` parameter for node spawning functions


## Done

- [x] Pathfinding/Navigation Components
- [x] Player Settings
- [x] Random populating Area2D
- [x] Add `groups` parameter for node spawning functions
- [x] Add debugging breakpoint shortcut input
