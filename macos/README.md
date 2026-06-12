# macOS defaults

One-shot script that applies developer-friendly system tweaks via `defaults write`.

## Files

- `defaults.sh` — run once on a fresh machine (idempotent, safe to re-run)

## Run it

```sh
bash defaults.sh
```

Finder and Dock are restarted at the end. Some keyboard / global changes need a logout to fully apply.

## What it changes

**Finder**
- Show hidden files
- Show all file extensions
- Show path bar + status bar
- Don't write `.DS_Store` on network / USB volumes
- Disable extension-change warning
- Default to list view

**Keyboard**
- Fast key repeat (`KeyRepeat=2`, `InitialKeyRepeat=15`)
- Disable autocorrect, smart quotes, smart dashes (annoying in code/markdown)
- Full keyboard access (Tab moves between all UI controls)

**Dialogs**
- Expand Save / Print panels by default

**Dock**
- Auto-hide on, no show/hide delay

**Screenshots**
- Save to `~/Screenshots` if that directory exists

## Adjusting

Open `defaults.sh` and comment out anything you don't want. Each setting is one line, so it's easy to keep just the parts you like.

## Inspecting / reverting

Read a value:

```sh
defaults read com.apple.finder AppleShowAllFiles
defaults read NSGlobalDomain KeyRepeat
```

Reset a single key back to default:

```sh
defaults delete com.apple.finder AppleShowAllFiles
killall Finder
```

Nuclear option — reset an entire domain (rarely needed):

```sh
defaults delete com.apple.finder
killall Finder
```

## Reference

- Full list of every `defaults` key macOS understands: [macos-defaults.com](https://macos-defaults.com/)
- Apple's docs: `man defaults`
