---
name: project-plan
description: Set up and maintain this project repo's planning documents (PROMPT.md, VISION.md, PLAN.md, HISTORY.md). Use when the user wants to start planning a project, gather resources for a plan, write or generate the plan, bring an older PLAN.md or TODO.md into this layout, or see what is left to do.
---

# Project planning documents

A project is planned in four files at the root of the project repo.
`.claude/rules/project.md` ("Planning documents") has the rules for keeping them up to date; this skill has the procedures.
Skeletons for all four are in [`templates/`](templates/).

| file | what it holds |
|---|---|
| `PROMPT.md` | The seed prompt: scope, responsibilities, the resources to read, and what the vision and plan must contain |
| `VISION.md` | What is being built and why: architecture, principles, names, and a dated decision log |
| `PLAN.md` | Open and future work only, starting with `## Now` |
| `HISTORY.md` | Completed work, newest first |

## Pick the stage

Look at which files exist, tell the user which stage applies, and do that stage only.

| state of the repo | stage |
|---|---|
| No `PROMPT.md` and no `PLAN.md` | [Gather](#gather-write-promptmd) |
| `PROMPT.md` but no `PLAN.md` | [Generate](#generate-write-visionmd-planmd-and-historymd) |
| `PLAN.md` that isn't in the layout: no `HISTORY.md`, ticked boxes in it, no `## Now`, or a `TODO.md` next to it | [Migrate](#migrate-an-older-plan) |
| All in place | [Status](#status) |

In every stage, write the files and leave them uncommitted for the user to review.
Commit when they say so.

## Gather: write `PROMPT.md`

The goal is a prompt that a fresh session could turn into a good vision and plan with no other context.

1. **Ask the user** for what you can't find out yourself: the goal, their own responsibilities in it, the deliverables and deadlines, what is out of scope, and decisions already made.
2. **Take stock of the resources.**
   - The code repos in `repos.txt`: read each one's `README.md`, `CLAUDE.md` and `AGENTS.md`.
   - The material already in this repo (papers, proposals, notes, data descriptions).
   - The shared reference library: read `~/proj/ref/INDEX.md` and note the groups that matter here.
3. **Find the gaps.** List the resources that would help but aren't on disk: papers, manuals, repos to clone, data, prior art, things to ask collaborators for.
   Help the user add them.
   Material for this project alone goes in this repo, with an index file.
   Material that other projects could use goes in the reference library, following `~/proj/ref/CLAUDE.md`.
   Whatever can't be added yet goes in the prompt as a resource still wanted.
4. **Write `PROMPT.md`** from [`templates/PROMPT.md`](templates/PROMPT.md).
   - Put the resources in a numbered "Read first" list, in the order to read them, with a path for each and the part that matters.
   - Prior art (old code, prototypes) goes last, to be read after forming a view from the requirements.
   - Say what the plan should contain, and list the questions it must raise with the user.
5. Stop there. The user reviews and edits the prompt before the next stage.

## Generate: write `VISION.md`, `PLAN.md` and `HISTORY.md`

This works best in a fresh session, so the plan comes from the prompt and the resources, not from a long conversation.
If this session already holds a lot of other context, suggest starting a new one.

1. Follow `PROMPT.md`: read what it lists, in its order.
2. Write **`VISION.md`** from [`templates/VISION.md`](templates/VISION.md): the architecture and its rationale, the design principles, the names, and a decision log holding the decisions already made, each with its date and status.
3. Write **`PLAN.md`** from [`templates/PLAN.md`](templates/PLAN.md).
   - `## Now` holds the open steps of the first phase as a flat checklist.
   - Later phases have checkable steps, a deliverable, and a way to verify them.
   - Link to files instead of copying their text. Keep architecture and rationale in `VISION.md`.
   - Collect everything the user must answer under "Open questions", each with a recommendation and the phase it blocks.
4. Write **`HISTORY.md`** from [`templates/HISTORY.md`](templates/HISTORY.md), with a first entry for the work done so far: the project set-up and the resources gathered.
5. Add a status line under the title of `PROMPT.md`: `> Status: used on <date> to write VISION.md and PLAN.md. Kept as history; the plan is edited in place.`
6. Update the project's `CLAUDE.md` if it describes these files, and finish by listing the open questions for the user.

## Migrate an older plan

Nothing may be lost: every item in the old files ends up in exactly one of the new ones.

1. Read the current `PLAN.md`, `TODO.md` (if any), `VISION.md` (if any), `CLAUDE.md`, and the git logs of this repo and of the code repos (for dates, versions and what was really done).
2. Sort every item:
   - **Open work** stays in `PLAN.md`. The steps open right now go under `## Now` at the top, including small chores from `TODO.md`.
   - **Finished work** goes to `HISTORY.md`, grouped into entries by unit of work, newest first.
     For each, say what now exists and how it differed from the plan.
     Check doubtful items against the repos instead of trusting a ticked box.
   - **Architecture, rationale and decisions** go to `VISION.md`. Create it if it is missing.
     Keep existing decision ids (such as `D3`), and fix references that cite them as part of `PLAN.md`.
   - **Open questions** become one list in `PLAN.md`, without the ones already decided.
3. Delete `TODO.md`. Keep `PROMPT.md`, and give it the status line from the Generate stage if it has none.
4. Update the references to these files in `CLAUDE.md` and elsewhere in the repo.
5. Check the result:
   - `grep -n '\[x\]' PLAN.md` finds nothing;
   - each item of the old files (`git show HEAD:PLAN.md`, `git show HEAD:TODO.md`) is in exactly one new file;
   - relative links resolve.

## Status

1. Check `## Now` against reality: for each step, look at the repos (and package indexes, if a step is a release) to see whether it is in fact done.
2. Move finished steps to `HISTORY.md`, as the rules describe.
3. When `## Now` is empty, promote the next phase's steps into it.
4. Report what is left: the `## Now` list, then the open questions that block it.
