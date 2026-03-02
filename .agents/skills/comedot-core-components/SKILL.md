---
name: comedot-core-components
description: Core composition guidelines, lifecycle iron-rules, and component dependency constraints for Comedot.
---

# Comedot Core Component Architecture (The Iron Rules)

This skill documents the most fundamental rules of the Entity-Component architecture in the Comedot framework.

## 1. The `super._ready()` Iron Rule
If you create a new Custom Component and override the `_ready()` function, you **MUST** call `super._ready()` immediately.

```gdscript
class_name CustomComponent extends Component

func _ready() -> void:
    super._ready() # CRITICAL: If you miss this, the component will not register.
    # custom initialization below...
```
**Why?** `Component.gd` houses the registration retry mechanism in its own `_ready()`. Without `super._ready()`, the component cannot connect to its `parentEntity` if instantiated out of order.

## 2. Sibling Component Dependencies
Components do not exist in a vacuum. Sometimes, they act as controllers for other components.
- e.g., `ChaseComponent` computes pursuit vectors but it needs something to actually MOVE.
- **Rule:** If you use an AI/Logic component, you must supply the necessary "Body" components in the Godot Scene Tree.

**Required Sibling Nodes for ChaseComponent:**
1. `CharacterBodyComponent`
2. `InputComponent` (Provides the virtual velocity pipeline)
3. A physics integrator like `OverheadPhysicsComponent` or `PlatformerPhysicsComponent`.

## 3. Composition OVER Inheritance
You should almost never override `Entity.gd`. All behaviors belong in Components.
- To add a new skill to an entity: Add a new Node -> Attach Component script.
- Don't try to add physics variables natively to `Entity`. 

## 4. Querying Sibling Components
Instead of brittle `get_node("../../OtherNode")` logic, rely on the dictionary initialized by the Entity.
```gdscript
var health: HealthComponent = coComponents.get(&"HealthComponent")
if health:
    pass
```
