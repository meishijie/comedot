---
description: Trigger this command after fixing a deep, architecture-level bug to update the Agent Skills system
---

# 🐍 The Ouroboros ORO-Loop: Post Mortem & Self-Evolution Workflow

When you (the AI Agent) or the human developer successfully fix a complex Bug that cost significant time—especially bugs involving Godot parsing crashes, silent script failures, or missing framework lifecycle events—you must trigger this workflow to upgrade your own knowledge.

## Step 1: Root Cause Extraction
1. Briefly analyze the original bug.
2. Identify if this is a general software bug or a **Framework/Engine Gotcha** (e.g., Godot `.tscn` parsing rules, Comedot initialization order).

## Step 2: Toolchain Interceptor (Linter / Scanner) Priority
**Do not just write documentation.** Think: "How do I write a script to prevent this from ever happening again?"
- If it's a syntax or formatting issue: Write a Python script in `.agents/skills/tools/` to scan for this specific mistake (like we did with `tscn_guard.py`).
- Update your workflows (e.g., `/build-enemy`) to enforce running this new defense script.

## Step 3: Domain Skill Update
Update the specific domain skill Markdown file in `.agents/skills/` (e.g., `comedot-core-components` or `comedot-tscn-surgery`). Add the new finding to the "Anti-Patterns" section.

## Step 4: Validate Evolution
Run your newly created tool interceptor on the old, bugged version (if you have a backup) or a mock file to ensure it properly catches the ghost bug.

By running this workflow, you ensure the AI Agent's capabilities strictly improve relative to the specific engine blindspots.
