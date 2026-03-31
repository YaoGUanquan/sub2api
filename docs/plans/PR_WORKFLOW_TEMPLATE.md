# PR Workflow Template

## PR Title

Use format: `[type] short summary`

Examples:

- `[feat] add xxxxx`
- `[fix] resolve xxxxx`
- `[docs] update xxxxx`

## Branches

- Base branch: `main`
- Head branch: `feature/<topic>`

## 1. Sync Main First

```bash
git checkout main
git fetch upstream
git rebase upstream/main
git push origin main
```

## 2. Rebase Feature Branch to Latest Main

```bash
git checkout feature/<topic>
git fetch origin
git rebase origin/main
# if conflict: resolve -> git add <file> -> git rebase --continue
```

## 3. Pre-PR Local Checks

- Confirm branch is correct: `git branch --show-current`
- Check working tree: `git status -sb`
- Review commit list: `git log --oneline origin/main..HEAD`
- Run related tests/build for touched modules
- Update docs/ai-kb notes if behavior changed

## 4. Push Branch

```bash
git push -u origin feature/<topic>
```

If branch already exists:

```bash
git push
```

## 5. Open Pull Request

PR description should include:

- Background and goal
- Main changes
- Risk and rollback considerations
- Test/validation evidence
- Screenshots or request/response examples when needed

## 6. Post-Merge Follow-up

- Sync local `main` again
- Delete merged feature branch locally and remotely if no longer needed
- Move related plan docs to `docs/archive/` when completed
