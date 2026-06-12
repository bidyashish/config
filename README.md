# config

Personal dotfiles and developer-environment setup for replicating my macOS local PC on a fresh machine.

Covers shell (fish), terminal multiplexer (tmux), editor (Zed), Claude Code, git, Node (nvm), Python (uv), Homebrew packages, and macOS defaults.

## Layout

Each folder has its own `README.md` cheatsheet — open the link for tool-specific commands and tips.

```
config/
├── tmux/         → ~/.tmux.conf                  prefix Ctrl+Space, panes, sessions
├── fish/         → ~/.config/fish/...            shell config, nvm autoload, killport
├── claude/       → ~/.claude/settings.json       Claude Code global settings
├── git/          → ~/.gitconfig + ~/.config/git/ignore
├── zed/          → ~/.config/zed/settings.json
├── node/         default-version                 node major pinned for nvm
├── python/       default-version                 python version pinned for uv
├── brew/         Brewfile                        `brew bundle` package list
├── macos/        defaults.sh                     dev-friendly system defaults
└── install.sh    bootstrap (symlinks everything)
```

| Folder | Cheatsheet |
| ------ | ---------- |
| tmux   | [tmux/README.md](tmux/README.md) — attach/detach, panes, copy mode |
| fish   | [fish/README.md](fish/README.md) — keys, syntax, abbreviations, PATH |
| git    | [git/README.md](git/README.md) — aliases, common recipes, defaults explained |
| claude | [claude/README.md](claude/README.md) — settings + slash commands |
| zed    | [zed/README.md](zed/README.md) — keys, vim mode, tasks |
| brew   | [brew/README.md](brew/README.md) — bundle, dump, day-to-day |
| node   | [node/README.md](node/README.md) — nvm setup + nvm.fish plugin |
| python | [python/README.md](python/README.md) — uv workflow, venvs, pipx, system python |
| macos  | [macos/README.md](macos/README.md) — what `defaults.sh` does, how to revert |

## What's in here

- **tmux** — `Ctrl+Space` prefix, mouse on, truecolor, 50k scrollback, windows numbered from 1, `|`/`_` splits that open in the current directory, vim-style pane nav (`h/j/k/l`) and copy mode, `Alt+←/→` to cycle windows, `prefix r` to reload.
- **fish** — adds `~/.local/bin` to `PATH`, sets `$EDITOR` (nvim, falling back to vim), auto-inits `starship`/`zoxide`/`direnv`/`fzf` when present, fzf search backed by `fd` with a `bat` preview on `Ctrl+T`, `eza` ls aliases, `bat` as `cat`, `g`/`lg`/`..`/`...` abbreviations, integrates `nvm` (see Node below), plus a `killport <port>` helper.
- **claude** — global Claude Code settings: a lean profile — non-essential traffic off, extended thinking off, `effortLevel: xhigh`, subagents (`Task`) denied, hooks/skills/workflows disabled, no commit attribution (see [claude/README.md](claude/README.md)).
- **git** — opinionated defaults (`pull.rebase`, `push.autoSetupRemote`, `init.defaultBranch=main`, `fetch.prune`, `rerere.enabled`, `diff.algorithm=histogram`, `merge.conflictStyle=zdiff3`, `branch.sort=-committerdate`, `commit.verbose`) plus aliases (`st`, `co`, `br`, `lg`, `last`, `undo`, `amend`, `pushf`, `wip`, `cleanup`). Editor comes from `$EDITOR` (set by fish). Global ignore covers macOS junk, `node_modules`, `.venv`, `target/`, `.env`, editor artefacts.
- **zed** — fish as terminal shell, AI disabled, left-docked project panel, One Dark theme.
- **node** — `default-version` file (currently `24`) — used as the `nvm install <version>` target.
- **python** — `default-version` file (currently `3.13`) for `uv`. Workflow is `uv` for projects/venvs, `pipx` for global CLIs, brew Python only as a system fallback.
- **brew** — `Brewfile` with daily-driver tools: `fish`, `tmux`, `starship`, `neovim`, `gh`, `lazygit`, `fzf`, `ripgrep`, `fd`, `bat`, `eza`, `zoxide`, `jq`, `direnv`, `tldr`, `python@3.13`, `uv`, `pipx`, `rustup`, `hf`, `llama.cpp`, `ffmpeg`, `yt-dlp`, `mactop`, `stripe-cli`, `docker-desktop`.
- **macos** — `defaults.sh` toggles Finder hidden files, fast key repeat, autocorrect off, Dock auto-hide, no `.DS_Store` on network volumes.

## Install

### Option A — bootstrap (recommended)

```sh
git clone https://github.com/bidyashish/config.git ~/Developer/config
cd ~/Developer/config

# 1. symlink dotfiles
./install.sh

# 2. install packages
brew bundle --file=brew/Brewfile

# 3. apply macOS defaults
bash macos/defaults.sh
```

Then set up Node (see below) and open a new shell.

### Option B — manual

Cherry-pick from `install.sh`. Each `link` line maps repo path → home path.

## Node via nvm

The repo doesn't vendor nvm — install it once on a fresh machine, then `fish/conf.d/nvm.fish` activates the default node automatically.

```sh
# 1. install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# 2. install + alias the version pinned in this repo
NODE_VERSION=$(cat ~/Developer/config/node/default-version)
bash -c "source ~/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION"

# 3. (optional, recommended for fish) install fisher + nvm.fish for native fish support
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | fish -c 'source && fisher install jorgebucaran/fisher jorgebucaran/nvm.fish'
```

Without the `nvm.fish` plugin, `fish/conf.d/nvm.fish` still falls back to putting the default node's `bin/` on `PATH`, so `node`/`npm` work — you just can't switch versions inside fish without bash.

## Prerequisites

- macOS (paths assume `$HOME` on darwin)
- [Homebrew](https://brew.sh) — `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Claude Code (installed separately) for the `claude/` settings to take effect

To make fish the default shell after `brew bundle`:

```sh
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

## Keeping it in sync

Refresh the `Brewfile` from the current machine:

```sh
brew bundle dump --file=brew/Brewfile --force
```
