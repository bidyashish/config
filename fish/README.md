# fish cheatsheet

Friendly interactive shell with autosuggestions, syntax highlighting, and sane defaults — no `.bashrc` archaeology.

## Files

- `config.fish` → `~/.config/fish/config.fish` (PATH, `$EDITOR`, tool inits, aliases, abbreviations)
- `conf.d/nvm.fish` → `~/.config/fish/conf.d/nvm.fish` (nvm autoload)
- `functions/killport.fish` → `~/.config/fish/functions/killport.fish` (`killport <port>`)

Anything dropped into `~/.config/fish/functions/<name>.fish` becomes a command named `<name>`, lazy-loaded on first use. Anything in `~/.config/fish/conf.d/*.fish` runs at shell start.

## Day-to-day keys

| Key             | Action                                          |
| --------------- | ----------------------------------------------- |
| `→` / `End`     | accept the grey autosuggestion                  |
| `Alt+→`         | accept one word of the suggestion               |
| `Tab`           | complete / show options                         |
| `Ctrl+R`        | search history (interactive)                    |
| `Ctrl+P` / `Ctrl+N` | prev / next history line                    |
| `Alt+L`         | list directory contents                         |
| `Alt+S`         | prepend `sudo ` to the current command          |
| `Ctrl+W`        | delete last word                                |
| `Ctrl+U`        | delete to start of line                         |

## Syntax that bites bash users

```fish
# variables
set name value           # local
set -x NAME value        # exported (env var)
set -U NAME value        # universal — persists across all fish sessions

# command substitution: no $(...), no backticks
set files (ls)
echo (date)

# conditionals
if test -f file.txt; echo "exists"; end
if command -q rg;    echo "ripgrep installed"; end

# loops
for f in *.md; echo $f; end

# pipes & redirection are normal: | > >> 2>&1
```

No `&&` / `||` — use `; and` / `; or`:

```fish
make build; and make test; or echo "failed"
```

## Managing your shell

```fish
funced killport         # edit a function in $EDITOR, auto-save on exit
funcsave killport       # persist a function defined interactively
functions               # list all functions
functions killport      # show source of a function

abbr -a gst 'git status'    # abbreviation: expands when you hit space
abbr                        # list abbreviations
```

Abbreviations beat aliases: they expand visibly so you see the real command before running it.

## PATH

```fish
fish_add_path ~/bin                    # session-only
fish_add_path -g ~/bin                 # global (this fish only)
fish_add_path -U ~/bin                 # universal (every fish, persisted)
echo $PATH | tr ' ' '\n'               # inspect
```

## Useful built-ins

```fish
killport 3000           # custom — kills whatever is on port 3000
prevd / nextd           # cd history (also Alt+← / Alt+→)
cdh                     # interactive cd history picker
help                    # opens fish docs in browser
fish_config             # web UI for colors / prompt / functions
```

## Shortcuts in this config

| Shortcut           | Expands to / does                                                 |
| ------------------ | ----------------------------------------------------------------- |
| `g`                | `git` (abbreviation)                                              |
| `lg`               | `lazygit` (abbreviation)                                          |
| `..` / `...`       | `cd ..` / `cd ../..` (abbreviations)                              |
| `ls` / `ll` / `lt` | `eza` / `eza -la --git` / `eza --tree --level=2` (when installed) |
| `cat`              | `bat --paging=never` — syntax highlighting (when installed)       |

`$EDITOR` is `nvim` when installed, `vim` otherwise — git and everything else inherits it.

## Tools wired up by this config (when installed)

| Tool      | What it does                                  | Use                            |
| --------- | --------------------------------------------- | ------------------------------ |
| `starship`| fast, informative prompt                      | automatic                      |
| `zoxide`  | smart `cd` that learns                        | `z <part-of-dir-name>`         |
| `direnv`  | auto-loads `.envrc` when entering a dir       | `direnv allow` to authorise    |
| `fzf`     | fuzzy finder — searches via `fd`, `bat` preview | `Ctrl+T` files, `Ctrl+R` history, `Alt+C` cd |
| `nvm`     | node version manager                          | `nvm use 24` (needs `nvm.fish` plugin) |

Each one is guarded by `command -q` in `config.fish` — missing binaries are silently skipped.

## Reload config

```fish
exec fish              # replace current shell
# or just open a new terminal
```
