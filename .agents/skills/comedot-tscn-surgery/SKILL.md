---
name: comedot-tscn-surgery
description: MANDATORY defensive skills on safely modifying Godot .tscn files and avoiding silent parser crashes.
---

# 🛑 Tscn Surgery & Caching Gotchas (Extreme Warning)

This skill covers the ONLY safe way to manually or script-edit Godot `.tscn` (scene) files. 

## 1. THE INLINE COMMENT DEATH TRAP
**Rule:** NEVER, EVER use inline comments (e.g., `# ...`) in `.tscn` files.

You might be tempted to do this:
```ini
[node name="Ghost" type="CharacterBody2D"]
collision_layer = 4
collision_mask = 1 # ignore players
script = ExtResource("1_entity")
```

**What really happens:** 
Godot's C++ INI parser crashes silently at `collision_mask`. It drops **every single line after it in that block**. The `script = ExtResource("1_entity")` line is **deleted** by the engine during load. The Entity loses its script and the whole component architecture collapses without any clear stack trace.

**Correct Way:**
ONLY use full-line comments or don't comment at all.
```ini
[node name="Ghost"]
# This is a full line comment. It is safe.
collision_mask = 1 
```

## 2. Dealing with UID Corruption (`invalid UID`)
When duplicating or hand-writing scenes, Godot's Internal Cache might throw validation red errors for `uid="uid://..."` pointing to wrong files.
- **Do NOT try to manually guess the new UID.**
- **The Fix:** Strip the `uid` attribute completely from the offending line.
```ini
# BAD:
[ext_resource type="Script" uid="uid://cxold_junk" path="res://Scripts/Entity.gd" id="1_entity"]

# GOOD (Fallback Mode): 
[ext_resource type="Script" path="res://Scripts/Entity.gd" id="1_entity"]
```
Godot will automatically resolve the `path`, rebuild the dependencies safely, and assign the true UID upon next run/save.

## 3. Mandatory Toolchain Validation
If you modify ANY `.tscn` file as an AI Agent, you MUST run this tool IMMEDIATELY before spinning up Godot:
```bash
python3 .agents/skills/tools/tscn_guard.py <file_path.tscn>
```
If it reports inline comments, REDO your work instantly.
