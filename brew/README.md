# brew cheatsheet

Homebrew is the macOS package manager. The `Brewfile` here is a snapshot of every package this setup expects.

## Files

- `Brewfile` — declarative list of formulae, casks, and taps

## Install everything

```sh
brew bundle --file=Brewfile
```

`brew bundle` is idempotent — re-running only installs what's missing. Add `--cleanup` to also *uninstall* anything not in the Brewfile (sharp edge — review first):

```sh
brew bundle --file=Brewfile cleanup --dry-run    # preview
brew bundle --file=Brewfile --cleanup            # actually remove
```

## Update the Brewfile from this machine

```sh
brew bundle dump --file=Brewfile --force
```

This rewrites the file from your currently-installed packages. Commit the diff.

## Day-to-day

```sh
brew install <pkg>            # add a package
brew install --cask <app>     # install a GUI app
brew uninstall <pkg>
brew search <term>
brew info <pkg>               # version, dependencies, caveats
brew list                     # all formulae
brew list --cask              # all casks
brew leaves                   # only top-level (not pulled in as deps)
brew deps --tree <pkg>        # what does this pull in
brew uses <pkg> --installed   # what depends on this
```

## Keeping things fresh

```sh
brew update                   # refresh formula definitions
brew outdated                 # show what could be upgraded
brew upgrade                  # upgrade everything
brew upgrade <pkg>            # one package
brew cleanup                  # delete old versions and cache
brew autoremove               # remove orphaned deps
brew doctor                   # diagnostics
```

## What's in this Brewfile

**Shells & multiplexers**: `fish`, `tmux`, `starship` (prompt)

**Editor**: `neovim` — `$EDITOR` everywhere (fish falls back to vim when it's missing)

**Git tooling**: `gh`, `git-filter-repo`, `lazygit` (TUI for git — try `lazygit` in any repo)

**Modern CLI replacements**:

| Tool      | Replaces / use                                         |
| --------- | ------------------------------------------------------ |
| `fzf`     | fuzzy finder over stdin — `Ctrl+T` files, `Ctrl+R` history |
| `ripgrep` | `grep` — `rg pattern`                                  |
| `fd`      | `find` — `fd pattern`                                  |
| `bat`     | `cat` with syntax highlighting — `bat file`            |
| `eza`     | `ls` — `eza -la --git`                                 |
| `zoxide`  | `cd` — `z <substring>` jumps to frecent dir            |
| `jq`      | JSON processor — `jq '.key' file.json`                 |

**Per-directory env**: `direnv` — auto-loads `.envrc` files (run `direnv allow` once per dir)

**Languages / runtimes**: `python@3.13`, `uv` (Python project + venv manager), `pipx`, `rustup`

**AI / ML**: `hf` (Hugging Face CLI), `llama.cpp`

**Media**: `ffmpeg`, `yt-dlp`

**Misc**: `tldr` (concise command examples), `mactop` (macOS top), `stripe-cli`

**Casks**: `docker-desktop`

## Pinning versions

By default Brewfile doesn't pin versions. If you need a specific version, use a versioned formula (e.g. `brew "python@3.12"` not `brew "python"`), or for real reproducibility use mise/nix.
