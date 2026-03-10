# /grade — Task Grader

Grade task $ARGUMENTS.

---

## Step 1: Load the task spec

Read `..claude/syllabus.md` to find the task. Identify:
- Task name and number
- Learning Objective
- Definition of Done
- Deliverable Artifacts (exact file paths)

Read `..claude/rubrics.md` to find the task-specific rubric checks for criterion 5 (Task Objective Mastery).

---

## Step 2: Read the artifact

Read every file listed in Deliverable Artifacts. Do not grade from memory or prior context alone.

---

## Step 3: Pass/Fail gates — run these first

```
□ Does the artifact exist at the correct file path specified in the task?
□ Does it satisfy every requirement in the Definition of Done?
□ (Code artifacts only) Does it run as documented?
```

**On the third gate:** For code artifacts — Python modules, dbt models, SQL, `compose.yml`, CI workflows, Makefiles — file existence is not enough. The artifact must be runnable from the documented workflow. A dbt model that won't compile, a Compose service that fails its healthcheck, or a Python module that can't be imported are gate failures regardless of how complete the file looks. If the artifact can't be run in this session, the learner must provide evidence it ran (log output, `dbt run` success, row count confirmation). If no evidence exists, state the gate as unverified and do not score.

If any gate fails: state what is missing clearly and **stop**. Do not proceed to scoring. Tell the learner exactly what needs to be fixed.

---

## Step 4: Score 0–2 on each criterion (max 10)

Be honest — don't inflate scores. A 1 means "mostly there with real gaps," a 2 means "genuinely solid."

1. **Clarity** — Is it crisp, precise, unambiguous, correct terminology?
2. **Completeness** — Are all required sections/fields present?
3. **Traceability** — Are there source links, cross-links, evidence? Can claims be verified?
4. **Consistency** — Does it align with the style guide, templates, and other artifacts?
   - File names follow `lowercase_with_underscores` convention
   - Resources cited using IDs from `..claude/resources.md` ([B3], [D7], etc.)
   - Markdown formatting is consistent (headings, lists, links)
   - Cross-references use correct relative paths and resolve
   - Header block present with all required metadata fields (where template applies)
   - Assumptions/Risks sections use the specified table format (where applicable)
   - Change Log is present and maintained (where applicable)
5. **Task Objective Mastery** — Does the output demonstrate the stated learning objective with thoughtful choices and explicit rationale? Use task-specific checks from `..claude/rubrics.md`.

---

## Step 5: Deliver the verdict

- **Verdict:** PASS (both gates met) or FAIL (a gate failed)
- **Score:** X/10
- Per-criterion feedback: what is there and what is missing or weak. Quote the Definition of Done or task-specific rubric checks when explaining deductions.
- **Never rewrite the artifact** — point to what needs fixing, don't show the corrected version.
- If score < 8, provide 2–3 prioritized improvement suggestions:
  - **Critical** (blocks learning objective — must fix)
  - **Important** (would improve score — should fix)
  - **Polish** (nice-to-have — optional)
  - For each: indicate effort ("5-min fix" vs. "requires rethinking the approach")

---

## Step 6: Post-PASS actions (only if verdict is PASS)

1. **Ask one meta-learning question** before updating anything:
   - "What was the hardest part of this task?"
   - "What would you do differently if you started over?"
   - "How does this task connect to earlier work you've done?"

2. **Update `..claude/progress.md`:**
   - Mark the task: `[x] Task X.Y — [name] (PASS, X/10, YYYY-MM-DD)`
   - Update the "Last updated" timestamp at the bottom

3. **Check README.md links:** Scan the Deliverable Artifacts from the task. For each file, confirm it appears in the "Links to Docs Index" section of `README.md`. If any are missing, add them in the format:
   ```
   - **[Short descriptive name]:** [`path/to/file.md`](./path/to/file.md)
   ```

4. **Write session notes:** Invoke the `/session-notes` skill.
