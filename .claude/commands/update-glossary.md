# /update-glossary — Add Learner-Authored Terms to Glossary

Add new terms to `docs/glossary.md` that were explicitly defined or confirmed by the learner in the current conversation.

---

## Procedure

1. **Read `docs/glossary.md`** to see what terms already exist.

2. **Identify candidate terms** from the conversation — terms where the learner wrote or explicitly confirmed the final wording. Do not generate definitions for terms that merely appeared in discussion.

3. **For each candidate term**, check both conditions:
   - [ ] The final definition wording was written or explicitly confirmed by the learner (not auto-generated)
   - [ ] The term does not already exist in `docs/glossary.md`

4. **Add only terms that pass both conditions.** Format to match the existing glossary:
   ```
   **Term:** Definition text here.
   ```

5. **Report** what was added. If nothing qualified, state that no learner-authored terms were found this session.

---

**Do not** auto-generate definitions. If the learner hasn't authored the wording, it does not go in the glossary.
