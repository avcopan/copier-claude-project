# copier-claude-project

A Copier template for Claude Code project repos (`~/proj/<name>`), whose code repos are cloned into `~/code/<name>/<repo>`.
`template/` (`_subdirectory`) is what gets generated.
The repo root has its own tooling, which mirrors the root of [copier-pixi-python](https://github.com/avcopan/copier-pixi-python) (tbump releases, Lefthook hooks, `pixi run init`/`hooks`), but the generated projects are deliberately bare-bones: no versioning, hooks, tests, or workflows.
[`README.md`](README.md) is the reference for how everything works.
Read the relevant section before changing anything.

## Workflow

- Generate a scratch project, including uncommitted template changes:
  `pixi exec --spec copier copier copy --vcs-ref=HEAD --defaults -d project_name=demo <abs path to this repo> <dest>`.
  Use absolute paths, because a relative template path is stored relative to the cwd.
  To test `bootstrap.sh` without touching `~/code`, set `CODE_DIR`.
- There is no automated template test; verify changes by hand in a scratch project (see "Testing the Template" in the README).
  Also test `pixi run copier-update` and releases by hand in a real project generated from the template.
- `pixi run pre-commit` runs this repo's hooks (shellcheck on all scripts, actionlint, clean-tree check).
- Releases: add CHANGELOG `[Unreleased]` entries, then `pixi run release X.Y.Z` (tbump tags and pushes; `release.yml` runs the hooks, then makes a GitHub release).
  The user does all pushes and releases: commit and prepare a release (CHANGELOG entries, passing hooks, clean tree), then say the version to use, but never run `git push` or `pixi run release`.
  `copier update` follows the latest tag.
  README-only changes are not released.

## Conventions

- Keep the template minimal: it should only contain the bones that every project needs.
- `template/scripts/copier-update.sh` and `conflicts.sh` are copies of the ones in `template/scripts/` of [copier-pixi-python](https://github.com/avcopan/copier-pixi-python); keep them in sync.
- `template/scripts/bootstrap.sh` is POSIX `sh`, never changes existing clones (except to add a missing `upstream` remote), and must keep supporting `<group>/<name>` paths (e.g. a reference library grouped by topic).
- Files the user owns after the first copy are listed in `_skip_if_exists` (`CLAUDE.md`, `repos.txt`).
  Instructions that should follow template updates go in `template/.claude/rules/project.md.jinja` instead.
- `project.md` is loaded in every session, so keep it to short, always-on rules.
  Procedures that are used now and then go in a skill under `template/.claude/skills/` (as `project-plan` does), with the rule pointing to it.
  Skill files have no `.jinja` suffix, so Copier copies them as they are.
- The planning documents (`PROMPT.md`, `VISION.md`, `PLAN.md`, `HISTORY.md`, and the files in `walkthroughs/`) are not template files: the `project-plan` skill writes them from the skeletons in its `templates/` folder.
  Keep the skeletons, the skill, the rule and the README's "Planning Workflow" section in agreement.
- README style as in copier-pixi-python's `CLAUDE.md`: one sentence per line, bold lead-ins.

## Pitfalls

- Claude Code loads the CLAUDE.md files of directories in `permissions.additionalDirectories` only for `--add-dir` with `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` (docs, 2026-11-07), so the rules file tells Claude to read each code repo's `CLAUDE.md` itself.
- A project generated from a dirty template records a nonexistent `_commit`, so `copier update` fails with "Unknown revision".
- Sandboxed agents: `.git/hooks` is read-only, so the user must run `pixi run init`; run `pixi run pre-commit` before committing.
