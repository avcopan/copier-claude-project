# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- A rule in `.claude/rules/project.md` to keep each code repo's `CLAUDE.md` standalone, with facts about the workspace kept in the project repo

## [0.0.1] - 2026-11-07

### Added

- Initial release of the template, generating Claude Code project repos with:
  - A `repos.txt` manifest of code repos, and `pixi run bootstrap` / `pixi run status` to clone them into `~/code/<project_name>/` and show their state
  - `.claude/settings.json`, which gives Claude Code access to `~/code/<project_name>/`
  - `.claude/rules/project.md`, with instructions for Claude on the project layout, and a `CLAUDE.md` for project-specific instructions
  - A minimal Pixi workspace, and `pixi run copier-update` for template updates
