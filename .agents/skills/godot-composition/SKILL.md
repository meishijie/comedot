---
name: godot-composition
description: Component-based composition patterns for Godot 4 entities.
---

# Godot Composition Skill

This skill documents best practices for working with the Comedot composition framework, specifically handling component registration, inheritance, and scene loading order.

## Core Patterns

### 1. Robust Component Registration
Components should not assume their parent `Entity` is available during `_enter_tree()`. Always implement a retry mechanism in `_ready()` to handle late registration.

```gdscript
func _ready() -> void:
    # One last try to find our parent entity if everything else failed
    if not self.parentEntity:
        var foundEntity: Node = self.findParentEntity()
        if foundEntity:
            self.registerEntity(foundEntity)
```

### 2. Component Inheritance
Subclasses of `Component` MUST call `super._ready()` if they override the `_ready` method. Failure to do so will bypass the registration retry logic and leave the component orphaned.

```gdscript
func _ready() -> void:
    super._ready() # CRITICAL: Ensures registration retry logic runs
    # ... component specific initialization ...
```

### 3. Flexible Weapon Interfaces
Avoid hard-coding weapon types in AI components. Use `has_method()` and `set()` to support varied weapon systems (e.g., projectiles vs. beams).

```gdscript
if weapon.has_method(&"fire"):
    weapon.call(&"fire")
elif "isEnabled" in weapon:
    weapon.set(&"isEnabled", true)
```

## Anti-Patterns to Avoid
- **Hard Dependencies**: Don't use `load()` or specific class types for weapons in turret AI.
- **Bypassing Parent**: Never manipulate the parent's physics directly without checking if `parentEntity` is valid.
- **Ignoring super._ready()**: Overriding `_ready()` without `super()` is the primary cause of "No parentEntity found" warnings.
