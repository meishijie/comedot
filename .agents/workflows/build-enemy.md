---
description: How developers and AI agents should build enemies
---

# Comedot Standard Build Enemy Workflow

When instructed to "create a new enemy" or "build an entity", you must follow this exact pipeline. 

1. **Start with the Template**
   Read the `skills/templates/base_enemy.tscn.template`. Copy its core structure into your new `.tscn` file. This guarantees that `CharacterBodyComponent`, `InputComponent`, and `OverheadPhysicsComponent` are present from the start.

2. **Add Custom Components**
   Add specific modules, e.g., `HealthComponent` or `ChaseComponent`.
   If overriding `_ready` in a new GDScript, double-check that `super._ready()` is invoked.

3. **Validate the Output**
   You MUST execute the defensive scanner to ensure you didn't accidentally include forbidden syntax:
   `python3 .agents/skills/tools/tscn_guard.py Entities/Enemies/New/YourEnemy.tscn`

4. **Wipe Transient UIDs (if copying)**
   If you copied lines from another Godot `.tscn`, you MUST clear the bad UID cache:
   `python3 .agents/skills/tools/clean_uids.py Entities/Enemies/New/YourEnemy.tscn`

5. **Run the Game**
   Use `mcp_godot45_run_project` to test if the game launches without a "Parent node is not an Entity" error.
