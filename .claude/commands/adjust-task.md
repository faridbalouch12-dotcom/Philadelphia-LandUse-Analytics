# /adjust-task — Syllabus Realignment

Realign syllabus tasks and progress tracker when a deliberate design choice makes a task irrelevant, changes its deliverable, or collapses multiple tasks.

Usage: `/adjust-task [description of deviation]`

---

## Step 1: Identify the deviation

State clearly:
- **What the syllabus says:** [task ID, deliverable, definition of done]
- **What the learner chose instead:** [their actual approach]
- **Why it diverges:** [the design choice driving it]

---

## Step 2: Check tradeoffs

Have a genuine conversation. Ask:
- What do you gain from this approach?
- What do you lose? (skills practiced, artifacts produced, safety nets)
- Does this create downstream problems for later tasks that depend on the original deliverable?

Do NOT skip this step. Do NOT rubber-stamp. If the tradeoff reveals a real problem, say so and work through it before proceeding.

---

## Step 3: Propose task modifications

Once the learner has defended the choice, propose one of:

| Action | When to use |
|--------|-------------|
| **MODIFY** | Task still applies but deliverable/DoD changes |
| **COLLAPSE** | Multiple tasks merge into one |
| **REMOVE** | Task is fully irrelevant given the new approach |
| **REPLACE** | New task better fits the learning objective |

For each affected task, show:
- Task ID and original description
- Proposed change
- Updated Definition of Done (if MODIFY/REPLACE)

---

## Step 4: Confirm with learner

Present all proposed changes and ask for confirmation before editing anything.

---

## Step 5: Update artifacts

After confirmation:
1. Update `.claude/syllabus.md` — modify task descriptions, DoDs, and deliverables (or mark removed tasks)
2. Update `.claude/progress.md` — adjust task list to match
3. If a removed/collapsed task was already graded, preserve the grade with a note

---

## Guardrails

- Do NOT auto-trigger — only invoke when a deviation is identified in conversation
- Do NOT skip the tradeoff conversation (Step 2)
- Do NOT modify tasks the learner hasn't deviated from
- The learner makes the decision; Claude facilitates the update
