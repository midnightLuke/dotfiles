---
name: plan-issue
description: Plan a GitHub issue with structured acceptance criteria. Use when asked to plan, draft, or create a GitHub issue.
argument-hint: "<description> [--type enhancement|bug|chore|documentation|test]"
user-invocable: true
allowed-tools: Bash, Read, Grep, Glob
---

# Plan Issue

Plan and create a GitHub issue with structured acceptance criteria.

## Command Options

- `<description>`: What the issue is about (required)
- `--type TYPE`: Issue type — `enhancement`, `bug`, `chore`, `documentation`, or `test` (inferred if not provided)

## Your task

### Step 1: Parse arguments

- Extract the description from `$ARGUMENTS` (everything before any `--` flags)
- Parse `--type TYPE` if provided — note it for later

### Step 2: Research context

- Determine the current repo owner and name by running `git remote get-url origin` and parsing the result
- Check for duplicate or related open issues using the `search_issues` MCP tool with keywords from the description
- If the issue touches specific code, search the codebase for relevant files and patterns

### Step 3: Infer issue type

If `--type` was not provided, determine from the description:

| Intent | Label |
|--------|-------|
| New functionality or capability | `enhancement` |
| Something is broken or wrong | `bug` |
| Infrastructure, tooling, dependencies | `chore` |
| Documentation, comments, README | `documentation` |
| Tests or coverage | `test` |

### Step 4: Draft the issue

**Title**: Concise imperative phrase, under 60 characters.
- `enhancement` → "Add X"
- `bug` → "Fix X"
- `chore` → "Update/Upgrade X"
- `documentation` → "Document X"
- `test` → "Add tests for X"

**Body** using this template:

```markdown
## Overview

<1-2 sentences: what this is and why it matters>

## Acceptance Criteria

- [ ] <specific, testable criterion>
- [ ] <specific, testable criterion>
- [ ] <...>

## Notes

<Implementation hints, constraints, related issues, or open questions — omit this section entirely if there's nothing useful to add>
```

Acceptance criteria guidelines:
- Each criterion must be independently testable ("returns 200 for valid input" not "works correctly")
- Aim for 3–6 criteria — enough to define done, not so many they become a spec
- Write from the perspective of how you'd verify completion

### Step 5: CHECKPOINT — present and confirm

Show the full draft to the user:
- Proposed title
- Type label (e.g. `enhancement`)
- Full issue body (rendered clearly)

**STOP**: Ask the user to confirm or request edits. Do not create anything until explicitly approved.

### Step 6: Create the issue

Once the user confirms, use the `issue_write` MCP tool with `method: "create"`, passing the title, body, and labels array with the type label.

Capture the issue URL and number from the response.

### Step 7: Report back

- Display the issue URL
- Suggest the natural next step: "When ready to implement, run `/resolve-issue <number>`"
