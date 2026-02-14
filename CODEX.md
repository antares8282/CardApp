# Codex “Agent Skills” docs vs. Claude Code `skill-creator-plus`

This note captures practical differences between:

- OpenAI Codex docs: `https://developers.openai.com/codex/skills/`
- This repo’s Claude Code skill: `.claude/skills/skill-creator-plus/SKILL.md`

## Differences

- **What each document is**: The Codex page is *runtime/system documentation* (how Codex discovers, loads, and invokes skills). `skill-creator-plus` is a *skill* (a framework for authoring skills) rather than a runtime spec.

- **Skill locations & precedence**:
  - **Codex** loads skills from multiple scopes/paths (repo, user, admin, system) and **overwrites by name** from lower-precedence scopes (e.g. `$CWD/.codex/skills`, `$REPO_ROOT/.codex/skills`, `~/.codex/skills`, `/etc/codex/skills`, plus bundled system skills).
  - **Claude Code skill-creator-plus** assumes skills live under `.claude/skills/` (as used by this repo) and focuses on authoring guidance, not multi-scope precedence rules.

- **Invocation model**:
  - **Codex** supports:
    - **Explicit invocation** via `/skills` or typing `$` to mention a skill (with the note that Codex web/iOS don’t support explicit invocation yet).
    - **Implicit invocation** when a task matches the skill’s description.
    - It also describes “progressive disclosure”: only name/description are loaded at startup; full skill instructions are read when invoked.
  - **Claude Code skill-creator-plus** treats “triggers” as authoring guidance (what users might say / when the skill should load), but doesn’t define an invocation UI or precedence mechanism.

- **Frontmatter/schema**:
  - **Codex** requires `name` and `description` in `SKILL.md` and supports optional `metadata.short-description` (user-facing).
  - **skill-creator-plus** uses `name`/`description` and recommends keeping descriptions short (100–200 chars) and trigger-focused; it doesn’t mention `metadata.short-description`.

- **Creation/install workflow**:
  - **Codex** recommends built-in skills: `$skill-creator` (bootstrap a new skill) and `$skill-installer` (install skills like `create-plan`).
  - **skill-creator-plus** provides local scripts (`init_skill.py`, `analyze_skill.py`, `upgrade_skill.py`, `package_skill.py`) and a scoring rubric (0–100) to iterate on skill quality.

- **Distribution model**:
  - **Codex** points to a curated GitHub repo (`openai/skills`) installable via `$skill-installer`.
  - **skill-creator-plus** includes a `.skill` packaging step via `scripts/package_skill.py` and is oriented around local packaging/distribution.

- **Guidance style**:
  - **Codex** emphasizes system mechanics (where skills live, how they’re loaded, and how they’re invoked).
  - **skill-creator-plus** is intentionally opinionated about *skill content quality*: “philosophy first”, explicit anti-patterns, and variation encouragement to avoid template-like outputs.

