#!/usr/bin/env bash
# Symlink dotfiles from this repo into $HOME.
# Existing files are backed up to <path>.backup-<timestamp>.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
    local src="$REPO_DIR/$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "skip: $src does not exist"
        return
    fi

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "ok:   $dest -> $src (already linked)"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mv "$dest" "$dest.backup-$STAMP"
        echo "back: $dest -> $dest.backup-$STAMP"
    fi

    ln -s "$src" "$dest"
    echo "link: $dest -> $src"
}

link tmux/tmux.conf            "$HOME/.tmux.conf"
link fish/config.fish          "$HOME/.config/fish/config.fish"
link claude/settings.json      "$HOME/.claude/settings.json"
link git/gitconfig             "$HOME/.gitconfig"
link git/gitignore_global      "$HOME/.config/git/ignore"
link zed/settings.json         "$HOME/.config/zed/settings.json"

# Every fish snippet/function in the repo gets linked individually, so
# fisher-managed files in the same directories are left alone.
for f in "$REPO_DIR"/fish/conf.d/*.fish; do
    link "fish/conf.d/$(basename "$f")" "$HOME/.config/fish/conf.d/$(basename "$f")"
done
for f in "$REPO_DIR"/fish/functions/*.fish; do
    link "fish/functions/$(basename "$f")" "$HOME/.config/fish/functions/$(basename "$f")"
done

echo
echo "Done. Open a new shell to pick up changes."
echo
echo "Optional next steps:"
echo "  brew bundle --file=$REPO_DIR/brew/Brewfile          # install packages"
echo "  bash $REPO_DIR/macos/defaults.sh                    # apply macOS dev defaults"
echo
echo "  # Node via nvm (install once, then 'nvm install \$(cat $REPO_DIR/node/default-version)'):"
echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
echo
echo "  # Fish + nvm.fish plugin for native fish support:"
echo "  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | fish -c 'source && fisher install jorgebucaran/fisher jorgebucaran/nvm.fish'"
