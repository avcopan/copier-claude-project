# <Step name> (<code repo>)

Step: `PLAN.md` → Now, <which item>. Decision log: `VISION.md`, <rows or dates>.
<Two or three sentences: what is wrong or missing today, and what the step changes.>

## Decisions (<YYYY-MM-DD>; record in `VISION.md` at the end)
<One bullet per design decision the user made, with enough detail to implement it without asking again.>
- <...>

## Where I left off (<YYYY-MM-DD>)
<Leave this section out until the work is interrupted. Then: the branch and any WIP commit, what is already done, and the **next** action.>

## Steps (in `<path to the code repo>`, on a feature branch)
1. **`<file>`**
   - <What to change, concretely: names, signatures, docstrings.>
2. **`<file>`**
   - <...>
3. **Tests**
   - <Which test files, and what each new test checks.>
4. **Docs**
   - <CHANGELOG entry, the repo's CLAUDE.md, user guide pages.>
5. **Check**: <the repo's check commands>. Then a quick manual check: <what to run, and what it should show>.
6. **Commit** in <code repo> ("<commit subject>").
7. **This repo**: add the decisions above to the `VISION.md` decision log. Move the step from `PLAN.md` to `HISTORY.md`, linking this walkthrough. Commit.
