---
description: Create a pull request in Azure DevOps
allowed-tools:
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(git branch:*)
  - Bash(git status:*)
  - Bash(git remote:*)
  - Bash(git rev-parse:*)
  - Bash(az repos pr:*)
  - Bash(az devops:*)
  - AskUserQuestion
argument-hint: "[--draft] or [custom title]"
model: haiku
---

# Azure DevOps Pull Request Creation

Analyze changes and create a well-documented pull request.

## Current Git State

```bash
!git branch --show-current
```

```bash
!git remote get-url origin
```

```bash
!git status -sb | head -1
```

## Unpushed Commits

```bash
!git log origin/main..HEAD --oneline 2>/dev/null || git log main..HEAD --oneline
```

## All Commits on This Branch (vs main)

```bash
!git log origin/main..HEAD --pretty=format:"%h %s" 2>/dev/null || git log main..HEAD --pretty=format:"%h %s"
```

## Files Changed vs Main

```bash
!git diff origin/main..HEAD --stat 2>/dev/null || git diff main..HEAD --stat
```

## Detailed Changes

```bash
!git diff origin/main..HEAD 2>/dev/null || git diff main..HEAD
```

## User Input

$ARGUMENTS

## Instructions

### Step 1: Pre-flight Checks

1. **Verify branch**:
   - If on `main`, STOP: "Cannot create PR from main branch. Create a feature branch first with `/branch`."

2. **Check for unpushed commits**:
   - If unpushed commits exist, use `AskUserQuestion` to ask:
     - Header: "Unpushed commits"
     - Question: "You have unpushed commits. What would you like to do?"
     - Options:
       - "Push now" (description: "Push commits to remote before creating PR")
       - "Continue anyway" (description: "Create PR without local commits (not recommended)")
   - If user selects "Push now", execute `git push` first
   - If push fails, abort PR creation

3. **Check for uncommitted changes**:
   - Warn user if there are uncommitted changes

4. **Verify Azure CLI**:
   - Check if `az` is available and logged in
   - If not, prompt: `az login`

### Step 2: Analyze Changes for PR Content

1. **Review ALL commits** on the branch (not just the latest)
2. **Categorize changes**:
   - New pipelines added
   - Pipeline modifications
   - CI/CD changes
   - Infrastructure changes
   - Bug fixes
3. **Identify the primary type** of change for the title

### Step 3: Generate PR Title

Based on conventional commits on the branch:
- If all commits are `feat:` -> Title: "feat: <summary of features>"
- If mixed types -> Title based on primary/most significant change
- Keep title under 80 characters
- Use imperative mood

**If user did not provide custom title in arguments:**
- Generate 2-3 title options based on the commits
- Use `AskUserQuestion` to present options:
  - Header: "PR title"
  - Question: "Which title would you like to use for this pull request?"
  - Options: 2-3 generated titles (mark best option as "(Recommended)")
  - User can select "Other" to provide custom title
- multiSelect: false

**Examples:**
- `feat(adf): add customer data ingestion pipeline`
- `fix(adf): correct linked service configuration`
- `ci: improve pipeline validation and deployment`

### Step 4: Generate PR Description

Use the project's PR template format from `docs/pull_request_template.md`:

**Scope values** (based on project structure):
- `adf` - Azure Data Factory changes
- `dbx` - Azure Databricks changes
- `metadata` - Metadata/SQL changes
- `ci` - CI/CD pipeline changes

### Step 5: Create the PR

1. **Parse user arguments**:
   - `--draft` flag -> create as draft PR
   - Custom title provided -> use it instead of generated

2. **Confirm PR creation** using `AskUserQuestion`:
   - Display the generated title and description
   - Header: "Create PR"
   - Question: "Ready to create pull request with this title and description?"
   - Options:
     - "Create PR" (description: "Create the pull request now")
     - "Edit title" (description: "Modify the PR title first")
     - "Cancel" (description: "Don't create PR")
   - multiSelect: false
   - If user selects "Edit title", ask for custom title via text response and re-confirm

3. **Build and execute the az command**:
   - First, write the description to a temporary file:
     ```bash
     cat > /tmp/pr_description.txt << 'EOF'
     <description content here>
     EOF
     ```
   - Then create the PR using the temp file:
     ```bash
     az repos pr create \
       --title "<title>" \
       --description "$(cat /tmp/pr_description.txt)" \
       --source-branch "<current-branch>" \
       --target-branch "main" \
       --auto-complete false \
       --org "https://dev.azure.com/brucity" \
       --project "InfraCore" \
       --repository "lz-dat-infra" \
       [--draft true if requested]
     ```
   - Clean up the temporary file after PR creation:
     ```bash
     rm -f /tmp/pr_description.txt
     ```

### Step 6: Post-Creation

1. **Show PR details**:
   - PR number/ID
   - PR URL (for easy access)
   - Status (draft or active)

2. **Suggest next steps**:
   - "View PR in Azure DevOps: <URL>"
   - "Add reviewers if needed"
   - "Monitor pipeline status"

## Error Handling

| Error | Action |
|-------|--------|
| Not logged into Azure CLI | Prompt: `az login` |
| No commits vs main | Inform user nothing to PR |
| Branch not pushed | Offer to push first |
| PR already exists | Show existing PR link |
| DevOps extension missing | Prompt: `az extension add --name azure-devops` |
| No default org/project | Suggest: `az devops configure --defaults organization=<url> project=<name>` |
