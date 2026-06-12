# Zed cheatsheet

Fast, native code editor. This config opts out of AI features (Claude Code lives in the terminal) and sets fish as the integrated terminal shell.

## Files

- `settings.json` → `~/.config/zed/settings.json`

## What's set

| Setting                  | Value          | Why                                                       |
| ------------------------ | -------------- | --------------------------------------------------------- |
| `terminal.shell.program` | `fish`         | Integrated terminal uses fish, matches your system shell  |
| `disable_ai`             | `true`         | No Zed AI prompts — Claude Code handles that              |
| `project_panel.dock`     | `left`         | File tree on the left                                      |
| `theme`                  | One Dark / One Light | Standard, easy on the eyes                          |
| `ui_font_size` / `buffer_font_size` | 16 / 15 | Slightly larger than default                         |

## Keys you'll use daily

| Key             | Action                                       |
| --------------- | -------------------------------------------- |
| `⌘P`            | quick-open file                              |
| `⌘⇧P`           | command palette                              |
| `⌘B`            | toggle project panel                         |
| `⌘\``           | toggle integrated terminal                   |
| `⌘F`            | find in current file                         |
| `⌘⇧F`           | find in project                              |
| `⌘D`            | select next occurrence (multi-cursor)        |
| `⌘⇧L`           | select all occurrences                       |
| `⌥↑` / `⌥↓`     | move line up / down                          |
| `⌘/`            | toggle line comment                          |
| `⌘.`            | code action / quick fix                      |
| `F2`            | rename symbol                                |
| `gd`            | go to definition (also `F12`)                |
| `⌘⇧O`           | go to symbol in file                         |
| `⌘T`            | go to symbol in project                      |

## Vim mode

Not enabled by default. If you want it, add to `settings.json`:

```jsonc
{
  "vim_mode": true
}
```

## Per-project settings

Drop a `.zed/settings.json` in any repo to override globally for that project. Common: project-specific formatters, LSP, theme.

## Tasks

Define repo-specific tasks in `.zed/tasks.json`:

```jsonc
[
  { "label": "Test", "command": "pnpm test", "use_new_terminal": false },
  { "label": "Typecheck", "command": "pnpm typecheck" }
]
```

Run with `⌘⇧P → task: spawn`.

## Reset / open defaults

`⌘⇧P → zed: open default settings` shows the full schema (read-only) so you can copy what you want into your custom settings.
