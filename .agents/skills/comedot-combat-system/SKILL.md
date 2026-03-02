---
name: comedot-combat-system
description: Rules for Comedot's Faction alignments, Damage Components, and Hitbox resolutions.
---

# Comedot Combat System Skills

This skill governs how entities interact with Health, Damage, and Hitboxes.

## 1. Faction Architecture
Comedot uses a universal `Faction` system mapped directly to `StringName`.
- Built-in Factions: `&"Players"`, `&"Enemies"`, `&"Neutrals"`
- **Rule**: Never hardcode group names like `"Enemy"`. Always query `parentEntity.faction` or rely on `FactionComponent` if present.
- Entities define their faction directly: `var faction: StringName = &"Enemies"` in `Entity.gd`.

## 2. Damage Application (DamageReceivingComponent)
Do NOT manually subtract health from a `HealthComponent`.
All damage MUST flow through the `DamageReceivingComponent`.

**Correct Flow**:
`Enemy Bullet` -> `AreaCollisionComponent` -> Detects `Player` Entity -> Calls `playerEntity.getComponent(&"DamageReceivingComponent").applyDamage(amount)`

**Why?**
The `DamageReceivingComponent` checks for Invulnerability (`isInvulnerable`), applies Defense mitigations, triggers Hit Shaders/Flash routines, and ONLY THEN instructs the `HealthComponent` to decrease. Bypassing it breaks the combat loop.

## 3. Hitboxes and Hurtboxes
- `AreaCollisionComponent` (and wrappers like `HitboxComponent`) handles Godot physical area intersections.
- Make sure `collision_mask` and `collision_layer` in the `.tscn` physical nodes strictly separate Players layer from Enemies layer to avoid unnecessary physics calculations. 

## 4. Death is an Event, Not a Command
When an entity's health reaches 0, the `HealthComponent` emits `healthDidDeplete`.
Components like `DeathComponent` or `ExplosionOnDeathComponent` listen for this signal to trigger animations and ultimately call `parentEntity.queue_free()`.
- Do not call `queue_free()` directly inside weapon logic when health is 0.
