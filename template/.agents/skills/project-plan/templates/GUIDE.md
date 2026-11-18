# <Step name> (<code repo>)

Step: `PLAN.md` → Now, <which item>. Time: <about N hours>. Builds on: <earlier step or file>.
<Two or three sentences: what is missing today, and what this step adds.>

The user writes the code. Each step below gives the skeleton (types, signatures, test stubs) and says what to implement.
Ask Claude for the boring parts: docstrings, derives, imports, `todo!()`/`...` bodies, repetitive tests.

## Progress
- [ ] Step 1: <title>
- [ ] Step 2: <title>
- [ ] Wrap-up
<Tick a step when its **Check** passes, with the commit hash. After an interruption, **Next:** says where to resume, plus the branch and any WIP commit.>

**Next:** Step 1.

<!-- Optional. Include only a reading that is highly relevant, e.g. one section of a paper or a few files of a reference implementation, with the part that matters. Otherwise delete this comment. -->
## Reading (≈ <N> min)
- <path or link, and the section to read, and why>

## Step 1: <title> (<minutes>)
<One or two sentences: what to implement and why it has this shape. Name the file.>

`<path/to/file>`:
```<lang>
<The skeleton to start from: struct or class definitions, function signatures, test stubs. Bodies are `todo!()`, `...`, or `pass`.>
```

<What the code must do: the cases, the edge cases, the choices already made (mention the `VISION.md` decision it follows).>

**Check:** `<command>` <and what it should show>.

## Step 2: <title> (<minutes>)
<Same shape. Keep steps small enough to finish and check in one sitting.>

## Wrap-up
1. Docs: <CHANGELOG entry, the repo's `CLAUDE.md`, user guide pages. Claude writes the docstrings.>
2. Check: <the repo's check commands>. Then a quick manual check: <what to run, and what it should show>.
3. Commit in <code repo> ("<commit subject>").
4. This repo: add the decisions to the `VISION.md` decision log, move the step from `PLAN.md` to `HISTORY.md` linking this guide, and commit.
