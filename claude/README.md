# Claude Code config

Global settings for [Claude Code](https://claude.com/claude-code). Per-project settings live in each repo's `.claude/` directory and override these.

## Files

- `settings.json` → `~/.claude/settings.json`

## What's set

A deliberately lean profile — no extra machinery — with reasoning effort maxed out. Drop effort per session when speed matters more (`/effort`).

| Key                                   | Value      | Why                                                            |
| ------------------------------------- | ---------- | --------------------------------------------------------------- |
| `effortLevel`                         | `xhigh`    | Max reasoning by default — drop per session with `/effort`       |
| `permissions.deny`                    | `["Task"]` | No subagents — keep all work in the main loop                    |
| `disableBundledSkills` / `disableAllHooks` / `disableWorkflows` / `disableAgentView` | `true` | No bundled skills, hooks, workflows, or agent view |
| `enabledPlugins`                      | `{}`       | No plugins                                                       |
| `attribution`                         | empty      | No co-author lines added to commits / PR bodies                  |
| `includeGitInstructions`              | `false`    | Skip the built-in git guidance in the system prompt              |
| `spinnerTipsEnabled`                  | `false`    | No tips while waiting                                            |
| `skipDangerousModePermissionPrompt`   | `true`     | Don't re-prompt every session when entering dangerous mode       |

## Environment variables

| Variable                                   | Value | Why                                                                  |
| ------------------------------------------ | ----- | --------------------------------------------------------------------- |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | `1`   | Umbrella switch — telemetry, error reporting, update checks, etc.      |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT`           | `1`   | Stay on the standard context window                                    |
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`    | `1`   | No automatic thinking-budget changes                                   |
| `MAX_THINKING_TOKENS`                      | `0`   | Extended thinking off                                                  |

## Useful in-session commands

| Command           | What it does                                                  |
| ----------------- | ------------------------------------------------------------- |
| `/help`           | list commands                                                 |
| `/config`         | open the config UI                                            |
| `/effort max`     | set effort level for this session (also `/fast` toggles fast mode) |
| `/clear`          | reset conversation context                                    |
| `/compact`        | summarise context to free up tokens                           |
| `/review [PR#]`   | run code review (this is a plugin command)                    |
| `/init`           | generate a `CLAUDE.md` in the current repo                    |

## Project-level overrides

Drop a `.claude/settings.json` in any repo to override these globally. Examples:

```jsonc
{
  // grant common read-only tools without prompting in this repo
  "permissions": {
    "allow": [
      "Bash(pnpm test:*)",
      "Bash(pnpm typecheck:*)",
      "Bash(git status)",
      "Bash(git diff:*)"
    ]
  }
}
```

A repo can also have:

- `CLAUDE.md` — long-lived instructions Claude reads at session start
- `.claude/skills/` — custom skills
- `.claude/hooks/` — shell scripts run on tool events

## Reset / inspect

```sh
# print the effective config
cat ~/.claude/settings.json

# wipe per-project overrides for the current repo
rm -rf .claude/settings.local.json
```
