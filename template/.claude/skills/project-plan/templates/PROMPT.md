# Prompt: write the project vision and plan

Use this prompt in a fresh Claude Code session in this repo to write `VISION.md` and `PLAN.md` (the `project-plan` skill, Generate stage).

---

<Two or three sentences: what the project is, what larger goal it serves, and what this plan covers.>
Write `VISION.md` and `PLAN.md` to review and refine with me before any code is written.
Don't write code, create repos, or change the code repos while doing this.

## Read first
<Numbered, in reading order. For each: the path, and the part that matters.>
1. `CLAUDE.md` and `.claude/rules/project.md` in this repo.
2. <The code repos: their README, CLAUDE.md, and the key source files.>
3. <Project material in this repo: papers, proposals, data descriptions.>
4. <Groups in the shared reference library (`~/proj/ref/INDEX.md`).>
5. <Prior art, to read only after forming your own view from the requirements.>

## My responsibilities
<What I have to deliver, in order, with deadlines if there are any.>

## Decisions already made
<Decisions the plan must respect, each with its reason.>

## What VISION.md should contain
- <The architecture: components, their roles, and how data flows between them.>
- <Design principles and naming rules.>
- A decision log holding the decisions above.

## What PLAN.md should contain
- **Goals and non-goals.** Name what is explicitly deferred.
- **Phases**, each with checkable steps, a deliverable, and a way to verify it.
  <Outline the phases you expect.>
- **Open questions** to resolve with me. At least:
  - <...>
- **Risks**, each with a mitigation.
- **Resources still wanted:** <what would help but isn't on disk yet>.

Keep both files easy to scan: short sections, checklists, and links to files instead of copied text.
