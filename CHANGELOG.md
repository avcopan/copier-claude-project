# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.0.6] - 2026-11-18

### Changed

- Step walkthroughs are now step **guides** in `guides/`: code skeletons (types, signatures, test stubs) and the steps for you to implement, each with a check, plus a `## Progress` checklist that replaces "Where I left off". The "Walk through a step" stage of `project-plan` is now "Write a guide for a step", and `templates/WALKTHROUGH.md` is now `templates/GUIDE.md`. Drills are dropped, readings are only for highly relevant material, and there is no decisions section
- Skills live in `.agents/skills/` (the agent-neutral location); `.claude/skills` is a symlink to it (`_preserve_symlinks: true` in `copier.yml`), because Claude Code only reads `.claude/`

### Migration

Projects made from an earlier version, before `copier update`:

1. `git mv walkthroughs guides` and fix the links to it (`grep -rn walkthrough`).
2. `git rm -r .claude/skills` and commit (copier can't replace a real folder with the symlink).
3. Run `pixi run copier-update`. It deletes the new skill files through the symlink, so restore them: copy `template/.agents/skills` from the template clone into `.agents/skills/`.

## [0.0.5] - 2026-11-13

### Added

- Step walkthroughs: `walkthroughs/YYYY-MM-DD-short-slug.md`, a detailed how-to for one `PLAN.md` step, linked from the step while it is open and from its `HISTORY.md` entry once done
  - A "Walk through a step" stage in the `project-plan` skill, which reads the code the step touches, asks for its design decisions, and writes the walkthrough from a new `WALKTHROUGH.md` skeleton
  - The `walkthroughs/` folder and its lifecycle in the "Planning documents" section of `.claude/rules/project.md`

### Changed

- `PROMPT.md` is deleted once the plan has been generated and reviewed, instead of being kept with a status line: the Generate stage of `project-plan` reminds you to delete it, the Migrate stage deletes it, and a `HISTORY.md` entry names the commit to recover it from

## [0.0.4] - 2026-11-11

### Added

- A planning workflow for projects, built on four files: `PROMPT.md` (the seed prompt), `VISION.md` (architecture and decision log), `PLAN.md` (open and future work only, starting with `## Now`), and `HISTORY.md` (completed work, and how it differed from the plan)
  - A `project-plan` skill (`/project-plan`) in `.claude/skills/`, which gathers resources and writes `PROMPT.md`, generates the vision and plan from it, migrates an older `PLAN.md` or `TODO.md` to this layout, and reports what is left to do
  - A "Planning documents" section in `.claude/rules/project.md`, which has Claude move each finished step from `PLAN.md` to `HISTORY.md`

## [0.0.3] - 2026-11-09

### Added

- An optional `upstream=<url>` field in `repos.txt`, for forks: `pixi run bootstrap` adds it as the `upstream` remote (also to existing clones that lack one, never changing an existing one), and `pixi run status` shows it and flags a missing or different one

## [0.0.2] - 2026-11-07

### Added

- A rule in `.claude/rules/project.md` to keep each code repo's `CLAUDE.md` standalone, with facts about the workspace kept in the project repo

## [0.0.1] - 2026-11-07

### Added

- Initial release of the template, generating Claude Code project repos with:
  - A `repos.txt` manifest of code repos, and `pixi run bootstrap` / `pixi run status` to clone them into `~/code/<project_name>/` and show their state
  - `.claude/settings.json`, which gives Claude Code access to `~/code/<project_name>/`
  - `.claude/rules/project.md`, with instructions for Claude on the project layout, and a `CLAUDE.md` for project-specific instructions
  - A minimal Pixi workspace, and `pixi run copier-update` for template updates
