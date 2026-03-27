---
name: plan-issue
description: Plan a GitHub issue with structured acceptance criteria and add it to a GitHub project. Use when asked to plan, draft, or create a GitHub issue.
argument-hint: "<description> [--project N] [--type enhancement|bug|chore|documentation|test]"
user-invocable: true
allowed-tools: Bash, Read, Grep, Glob
---

# Plan Issue

Plan and create a GitHub issue with structured acceptance criteria, then add it to a GitHub project.

## Command Options

- `<description>`: What the issue is about (required)
- `--project N`: GitHub project number to add the issue to (prompts if not provided)
- `--type TYPE`: Issue type — `enhancement`, `bug`, `chore`, `documentation`, or `test` (inferred if not provided)

## Your task

### Step 1: Parse arguments

- Extract the description from `$ARGUMENTS` (everything before any `--` flags)
- Parse `--project N` if provided — note it for later
- Parse `--type TYPE` if provided — note it for later

### Step 2: Research context

- Run `gh repo view --json name,owner,url` to identify the current repo
- Check for duplicate or related open issues: `gh issue list --search "<keywords from description>" --limit 10`
- If the issue touches specific code, search the codebase for relevant files and patterns

### Step 3: Infer issue type

If `--type` was not provided, determine from the description:

| Intent | Label | GitHub Issue Type |
|--------|-------|-------------------|
| New functionality or capability | `enhancement` | `Feature` |
| Something is broken or wrong | `bug` | `Bug` |
| Infrastructure, tooling, dependencies | `chore` | `Task` |
| Documentation, comments, README | `documentation` | `Task` |
| Tests or coverage | `test` | `Task` |

Note both the label (for `--label`) and the GitHub issue type (for the type field set after creation).

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

### Step 5: Identify GitHub project

- If `--project N` was provided, use that number
- Otherwise: run `gh project list --owner @me --limit 10`, present the list to the user, and ask which project to add the issue to
- If the user says "none" or "skip", proceed without adding to a project

### Step 6: CHECKPOINT — present and confirm

Show the full draft to the user:
- Proposed title
- Type label (e.g. `enhancement`) and GitHub issue type (e.g. `Feature`)
- Full issue body (rendered clearly)
- Target project (or "no project")

**STOP**: Ask the user to confirm or request edits. Do not create anything until explicitly approved.

### Step 7: Create the issue

Once the user confirms:

```bash
gh issue create \
  --title "<title>" \
  --body "<body>" \
  --label "<type-label>"
```

Capture the issue URL and extract the issue number from it.

### Step 7.5: Set the GitHub issue type

GitHub issue types (Bug, Feature, Task) are a separate field from labels and must be set via GraphQL after creation.

First, query the repository for available issue types and the issue's node ID:

```bash
gh api graphql -f query='
{
  repository(owner: "<owner>", name: "<repo>") {
    issue(number: <number>) { id }
    issueTypes(first: 20) { nodes { id name } }
  }
}'
```

If `issueTypes` returns nodes, find the one whose `name` matches the mapped GitHub type (`Bug`, `Feature`, or `Task`), then set it:

```bash
gh api graphql -f query='
mutation {
  updateIssue(input: { id: "<issue-node-id>", issueTypeId: "<type-node-id>" }) {
    issue { id issueType { name } }
  }
}'
```

If `issueTypes` returns null or an empty list, the repository has no issue types configured — skip this step silently.

### Step 8: Add to GitHub project

If a project was identified:

```bash
gh project item-add <N> --owner <owner> --url <issue-url>
```

### Step 9: Report back

- Display the issue URL
- Confirm which project it was added to (or note that it was skipped)
- Suggest the natural next step: "When ready to implement, run `/resolve-issue <number>`"
