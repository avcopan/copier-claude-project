# Claude Code Project Copier Template

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Pixi Badge](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/prefix-dev/pixi/main/assets/badge/v0.json)](https://pixi.sh)
[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-border.json)](https://github.com/copier-org/copier)

A [copier](https://copier.readthedocs.io/) template for setting up project repositories for working on code with [Claude Code](https://code.claude.com/).
It is a minimal companion to [copier-pixi-python](https://github.com/avcopan/copier-pixi-python) and [copier-pixi-rust](https://github.com/avcopan/copier-pixi-rust).
This is primarily for my own development.

## Layout

Each project has a private project repository, which holds the context for Claude Code, and a parent folder for the code repositories being developed in it.
For a project named `sm`:

| path | Git repo? | what it holds |
|---|---|---|
| `~/proj/sm/` | yes (private) | Instructions for Claude, notes, TODOs, plans, reference files, and the `repos.txt` list of code repos |
| `~/code/sm/` | no | Just a parent folder for the code repos |
| `~/code/sm/<repo>/` | yes | The code repositories being developed, cloned by `pixi run bootstrap` |

The project repo never tracks the commits or branches of the code repos.
Use the same paths on every machine, since Claude Code stores session history and memory by the project's absolute path.

## Features

- A `repos.txt` list of code repos, which `pixi run bootstrap` clones into `~/code/<project_name>/`
- Claude Code access to the code repos, with `.claude/settings.json`
- Instructions for Claude on the layout, in `.claude/rules/project.md`
- A planning workflow, with the `/project-plan` skill: a seed prompt, a vision, a plan of the open work, and a history of the completed work
- A [Pixi](https://pixi.sh/) workspace, for dependencies and tasks to run and test the project's code
- Updates against template changes with `pixi run copier-update`

## Instructions

### Install

First, install Pixi using the command shown [here](https://pixi.prefix.dev/latest/installation/).
Then install Copier as follows.

```sh
pixi global install copier
```

### Create a Project

Use the following command to create a new project from this template.

```sh
copier copy gh:avcopan/copier-claude-project ~/proj/<project_name>
```

Copier will prompt you for the project name, which must match the directory name, and an optional one-line description.
Then initialize the project as printed at the end:

1. **Initialize the repository.**
   Run `pixi install` (which creates `pixi.lock`), then `git init -b main`, `git add --all`, and `git commit -m "Initial commit"`.
2. **Push to GitHub.**
   Follow [these instructions](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository) to create an empty private repository (without a README, license, or `.gitignore`), and push to it.
3. **Add the code repos.**
   Add them to `repos.txt` and run `pixi run bootstrap` (see [below](#add-code-repos)).
4. **Trust the folder.**
   The first time you run `claude` in the project, accept the workspace trust dialog, since Claude Code only applies the permissions in `.claude/settings.json` to trusted folders.

### Set Up on a New Machine

```sh
git clone <project repo URL> ~/proj/<project_name>
cd ~/proj/<project_name>
pixi run bootstrap
claude
```

### Usage

#### Generated Files

| file | owner | what it does |
|---|---|---|
| `repos.txt` | project | The code repos, one `<name> <url> [branch] [upstream=<url>]` line each |
| `scripts/bootstrap.sh` | template | Clones the missing repos (`pixi run bootstrap`) and shows the state of each one (`pixi run status`) |
| `CLAUDE.md` | project | Project-specific instructions for Claude |
| `.claude/rules/project.md` | template | General instructions for Claude: the layout, and how to work with the code repos |
| `.claude/skills/project-plan/` | template | The `/project-plan` skill, with skeletons for the planning documents (see [below](#planning-workflow)) |
| `.claude/settings.json` | template | Gives Claude Code access to `~/code/<project_name>/` |
| `pixi.toml` | both | The Pixi workspace, with the `bootstrap`, `status`, and `copier-update` tasks |
| `README.md` | both | Setup instructions |
| `scripts/copier-update.sh`, `scripts/conflicts.sh` | template | `pixi run copier-update` (see [below](#updating-against-template-changes)) |

Files owned by the project are created once and never touched by template updates (they are listed under `_skip_if_exists` in `copier.yml`).
Files owned by the template should not be edited, since edits to them can conflict with template updates.
Files owned by both are merged on updates as usual.
Put machine-specific Claude Code settings in `.claude/settings.local.json`, which is ignored by Git.

#### Add Code Repos

Add a line to `repos.txt` for each code repo, as follows.
```
<name>  <url>  [branch]  [upstream=<url>]
```
For a fork, `upstream=<url>` adds the original repo as the `upstream` remote (and fetches it), so the fork can be updated against it.
Then clone the new repos and commit.
```sh
pixi run bootstrap   # clones the missing repos into ~/code/<project_name>/<name>
pixi run status      # shows the state of each repo
```
`pixi run bootstrap` never changes existing clones (no pull, reset, or delete), so it is safe to run again.
The one exception is that it adds a missing `upstream` remote, so `upstream=<url>` can be added to the line of an existing clone.
An existing `upstream` remote is never changed: if its URL differs from `repos.txt`, `pixi run bootstrap` warns and `pixi run status` flags it.
A `<name>` can also be a `<group>/<name>` path, for repos organized into subfolders.
To clone somewhere else than `~/code/<project_name>`, set the `CODE_DIR` environment variable.

#### Claude Code Setup

`.claude/settings.json` adds `~/code/<project_name>/` to
[`permissions.additionalDirectories`](https://code.claude.com/docs/en/permissions), and allows Claude to read and edit files there without asking.
Since the whole folder is added, adding a repo does not require any change to the settings.

Claude Code does not load the `CLAUDE.md` files of additional directories on its own, so `.claude/rules/project.md` tells Claude to read each code repo's `CLAUDE.md`, `AGENTS.md`, and `README.md` before working in it.
Claude Code loads `.claude/rules/*.md` automatically, like `CLAUDE.md`.

#### Planning Workflow

A project is planned in four files at the root of the project repo, plus a `walkthroughs/` folder.
None of them is generated with the project: the `/project-plan` skill writes them when you ask for them, so a project without a plan (such as a reference library) stays bare.

| file | what it holds |
|---|---|
| `PROMPT.md` | The seed prompt that the vision and plan are generated from: scope, responsibilities, and the resources to read. Deleted once the plan exists |
| `VISION.md` | What is being built and why: architecture, principles, names, and a dated decision log |
| `PLAN.md` | Open and future work only, starting with a `## Now` section of the steps currently open |
| `HISTORY.md` | Completed work, newest first: what was done, where, and how it differed from the plan |
| `walkthroughs/` | Detailed how-tos for single `PLAN.md` steps, named `YYYY-MM-DD-short-slug.md` |

Run `/project-plan` in Claude Code.
It picks its stage from the files that exist:

| state of the repo | stage | what happens |
|---|---|---|
| No `PROMPT.md`, no `PLAN.md` | **Gather** | Claude asks about the goal and your responsibilities, takes stock of the code repos and reference material, helps add what is missing, and writes `PROMPT.md` for you to review |
| `PROMPT.md`, no `PLAN.md` | **Generate** | Claude follows the prompt and writes `VISION.md`, `PLAN.md`, and the first `HISTORY.md` entry. Best done in a fresh session |
| An older `PLAN.md` or `TODO.md` | **Migrate** | Claude sorts every item into open work (`PLAN.md`), completed work (`HISTORY.md`), or architecture and decisions (`VISION.md`), and deletes `TODO.md` and `PROMPT.md` |
| All in place | **Status** | Claude checks the `## Now` steps against the repos, moves the finished ones to `HISTORY.md`, and reports what is left |
| Any, when you ask to walk through a step | **Walk through** | Claude reads the code the step touches, asks you for its design decisions, and writes a walkthrough (decisions, ordered steps with files, verification) linked from the step |

From then on, `.claude/rules/project.md` tells Claude to keep the files current in every session:
a finished step is removed from `PLAN.md` and added to `HISTORY.md` in the same commit, with a note on how the work differed from the plan.
So `PLAN.md` always shows what is left, and `HISTORY.md` shows what was done.
A step's walkthrough is linked from `PLAN.md` while the step is open and from `HISTORY.md` once it is done, and the file is kept.
Once you have reviewed the generated plan, `PROMPT.md` is deleted, with a `HISTORY.md` entry naming the commit to recover it from, and the plan is edited in place from then on.

### Updating Against Template Changes

To update your project against changes to this template, run the following in a clean working tree.
```sh
pixi run copier-update
```
This works exactly as in
[copier-pixi-python](https://github.com/avcopan/copier-pixi-python#updating-against-template-changes):
it runs `copier update` against the latest [released version](#releasing-the-template) of the template, and commits the update if there are no conflicts, or else prints the conflicted files and the commands to commit the update.
To try out template changes that have not been released yet, run `pixi run copier-update --vcs-ref=HEAD`.

### Developing the Template

After cloning the template repository, set it up once as follows.
```sh
pixi run init
```
This installs the template repository's own pre-commit hooks, configured in [`lefthook.yaml`](lefthook.yaml).
They check for unresolved merge conflict markers, lint the shell scripts with [ShellCheck](https://www.shellcheck.net/) (`pixi run lint`) and the GitHub Actions workflows with [actionlint](https://github.com/rhysd/actionlint) (`pixi run workflows`), and then check that the working tree is clean.
You can also run them directly with `pixi run pre-commit`, and temporarily disable them with `pixi run hooks off` (and re-enable them with `pixi run hooks on`).
The [test workflow](.github/workflows/test.yml) runs them on GitHub Actions for every push.

### Testing the Template

There is no automated test, since the template is small.
To test a change, generate a scratch project from the working tree (including uncommitted changes) and try it out.
```sh
copier copy --vcs-ref=HEAD --defaults -d project_name=demo "$PWD" /tmp/demo
cd /tmp/demo
pixi install
CODE_DIR=/tmp/demo-code pixi run bootstrap
```

### Releasing the Template

The template is versioned and released in the same way as
[copier-pixi-python](https://github.com/avcopan/copier-pixi-python#releasing-the-template).
Describe your changes under the `[Unreleased]` heading in [`CHANGELOG.md`](CHANGELOG.md), and then trigger a release by running this command.
```sh
pixi run release <new version number>
```
This updates the version in `pixi.toml`, turns the `[Unreleased]` section of `CHANGELOG.md` into an entry for the new version, and creates a release commit tagged with the new version number, then pushes both the commit and the tag to GitHub.
The [release workflow](.github/workflows/release.yml) then runs the pre-commit hooks and posts the new release on GitHub.
`copier update` only picks up template changes once they are released.

## License

This project is licensed under the [MIT License](LICENSE).
