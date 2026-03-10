# /session-notes — Write Session Notes

Write a session notes file for the current session.

---

## Step 1: Determine the file path

File naming: `notes/claude_sessions/session_YYYY-MM-DD_task-X-Y.md`
- Use today's date and the task number from the current session (e.g., `session_2026-03-10_task-5-2.md`)
- If multiple tasks were completed this session, use the last one graded

**This folder is gitignored.** Private working space, not a versioned deliverable.

---

## Step 2: Write the session notes file

Cover the full arc of the conversation. Include:

- **Tasks completed** — task name, score, one-sentence summary of what was built
- **Key concepts discussed** — not just task deliverables; include tangents, confusions resolved, analogies that clicked
- **How concepts connect** — to the broader project and to upcoming work
- **Learner's meta-learning response** — quote it or paraphrase it (from the post-PASS question)
- **Links to relevant formal notes files** where they exist
- **Coming up next** — the next task and any concepts worth priming for

Do not include:
- Verbatim conversation transcripts
- Content that belongs in deliverable files
- Speculative conclusions not confirmed in conversation

**Tone:** Conversational. Write it like notes a colleague left for both of you to revisit — not a formal spec.

---

## Step 3: Always ask about an HTML visual

After writing the session notes file, always ask:

> "Would you like an HTML visual for [X]?"

Where X is the most concept-rich topic from the session — something that would be meaningfully clearer with a diagram, table comparison, or worked example. Always ask — do not gate this on whether you think it adds value.

If yes: create an HTML file named `session_YYYY-MM-DD_task-X-Y_[concept].html` in the same `notes/claude_sessions/` folder.
