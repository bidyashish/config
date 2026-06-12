# tmux cheatsheet

Terminal multiplexer — run many shells in one window, detach and reattach later, survive SSH disconnects.

This config rebinds the prefix to **`Ctrl+Space`** (instead of the default `Ctrl+b`).

## Files

- `tmux.conf` → symlinked to `~/.tmux.conf`

## Sessions (the persistent layer)

A session is a workspace that keeps running even after you close the terminal.

```sh
tmux                          # start an unnamed session
tmux new -s work              # start a session named 'work'
tmux ls                       # list sessions
tmux attach -t work           # reattach to 'work'
tmux attach                   # reattach to the last session
tmux kill-session -t work     # kill 'work'
tmux kill-server              # kill everything
```

**Detach** (leave it running, return to your shell): `Ctrl+Space  d`

**Reattach** later: `tmux a` (shorthand for `attach`).

## Windows (tabs inside a session)

Windows are numbered from **1** (custom — matches keyboard order) and renumber when one closes.

| Key                  | Action                       |
| -------------------- | ---------------------------- |
| `Ctrl+Space  c`      | new window (in current dir)  |
| `Ctrl+Space  r`      | reload tmux.conf (custom)    |
| `Ctrl+Space  ,`      | rename current window        |
| `Ctrl+Space  n`      | next window                  |
| `Ctrl+Space  p`      | previous window              |
| `Ctrl+Space  <N>`    | jump to window N             |
| `Ctrl+Space  w`      | pick window from a list      |
| `Alt+←` / `Alt+→`    | prev / next window (no prefix — custom) |
| `Ctrl+Space  &`      | close current window         |

## Panes (splits inside a window)

Splits open in the current pane's directory (custom).

| Key                | Action                         |
| ------------------ | ------------------------------ |
| `Ctrl+Space  \|`   | split vertical (custom)        |
| `Ctrl+Space  _`    | split horizontal (custom)      |
| `Ctrl+Space  ←↑↓→` | move between panes             |
| `Ctrl+Space  h/j/k/l` | move between panes, vim-style (custom) |
| `Ctrl+Space  z`    | zoom / unzoom current pane     |
| `Ctrl+Space  x`    | close pane (with confirm)      |
| `Ctrl+Space  {` / `}` | swap pane with prev / next  |
| `Ctrl+Space  q`    | flash pane numbers             |
| `Ctrl+Space  q  <N>` | jump to pane N               |

Mouse is on — you can also click to switch panes and drag pane borders.

## Copy mode (scrollback / search)

| Key                  | Action                          |
| -------------------- | ------------------------------- |
| `Ctrl+Space  [`      | enter copy mode (scrollback)    |
| `q`                  | leave copy mode                 |
| `Ctrl+u` / `Ctrl+d`  | page up / down                  |
| `/` then text        | search forward                  |
| `?` then text        | search backward                 |
| `n` / `N`            | next / previous match           |
| `v`                  | start selection (vi keys — custom) |
| `y`                  | copy selection and exit (custom)   |
| `Space` / `Enter`    | start selection / copy (also work) |
| `Ctrl+Space  ]`      | paste                           |

## Common recipes

**SSH and keep work alive:**

```sh
ssh user@host
tmux new -s long-job
# run something
# Ctrl+Space d to detach
# connection drops — that's fine
ssh user@host
tmux a -t long-job
```

**Multi-pane layout (editor + tests + shell):**

```
Ctrl+Space |     # split right → run tests here
Ctrl+Space _     # split bottom on left side → free shell
```

## Reload config without restarting

From inside tmux: `Ctrl+Space  r` (custom binding), or from a shell:

```sh
tmux source-file ~/.tmux.conf
```
