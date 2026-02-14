---
name: theone-codex-skills
description: Project context for TheOne: Codex agent skills vs Claude skill-creator-plus. Use when editing CODEX.md, comparing skill systems, or working on skill authoring, locations, invocation, or distribution in this repo.
---

# TheOne: Codex vs skill-creator-plus

This project documents differences between **OpenAI Codex** skill docs and **Claude Code skill-creator-plus**. Apply this skill when working in this repo or when the user refers to CODEX.md or skill systems comparison.

## Reference: CODEX.md

The canonical comparison lives in **CODEX.md** at the project root. Key points:

### What each document is

- **Codex** (`https://developers.openai.com/codex/skills/`): runtime/system docs (how Codex discovers, loads, invokes skills).
- **skill-creator-plus** (`.claude/skills/skill-creator-plus/SKILL.md`): a *skill* for authoring skills, not a runtime spec.

### Skill locations and precedence

- **Codex**: Multiple scopes; loads from paths like `$CWD/.codex/skills`, `$REPO_ROOT/.codex/skills`, `~/.codex/skills`, `/etc/codex/skills`, plus system skills. **Overwrites by name** from lower-precedence scopes.
- **skill-creator-plus**: Skills under `.claude/skills/`; focus on authoring, not multi-scope precedence.

### Invocation

- **Codex**: Explicit (`/skills`, `$` to mention a skill; web/iOS may not support yet). Implicit when task matches skill description. Progressive disclosure: name/description at startup; full instructions when invoked.
- **skill-creator-plus**: “Triggers” as authoring guidance; no defined invocation UI or precedence.

### Frontmatter / schema

- **Codex**: Requires `name` and `description` in SKILL.md; optional `metadata.short-description`.
- **skill-creator-plus**: Uses `name`/`description`; short (100–200 chars), trigger-focused; no `metadata.short-description`.

### Creation and distribution

- **Codex**: Built-in `$skill-creator`, `$skill-installer` (e.g. install `create-plan` from `openai/skills`).
- **skill-creator-plus**: Local scripts (`init_skill.py`, `analyze_skill.py`, `upgrade_skill.py`, `package_skill.py`) and scoring rubric; `.skill` packaging via `package_skill.py`; local packaging/distribution.

### Guidance style

- **Codex**: System mechanics (where skills live, load order, invocation).
- **skill-creator-plus**: Content quality—philosophy first, anti-patterns, variation to avoid template-like output.

## When to use this skill

- Editing or discussing **CODEX.md**.
- Comparing **Codex** vs **Claude / skill-creator-plus** behavior or docs.
- Questions about **skill locations**, **precedence**, **invocation**, or **distribution** in either system.
- Working on **skill authoring** or **SKILL.md** structure in this project.

## Project layout

- **CODEX.md**: Main comparison document (single primary file in this repo).
- **.cursor/skills/theone-codex-skills/SKILL.md**: This embedded skill for agent context.

Keep CODEX.md as the source of truth; this skill summarizes it for the agent.
