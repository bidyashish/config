# Environment -----------------------------------------------------------------
fish_add_path -g $HOME/.local/bin

# Default editor: nvim when installed, vim otherwise.
# git picks this up too — no core.editor in gitconfig, so $EDITOR is the
# single source of truth.
if command -q nvim
    set -gx EDITOR nvim
else
    set -gx EDITOR vim
end

# Interactive-only setup --------------------------------------------------------
if status is-interactive
    # Tool inits — each guarded by `command -q` so missing binaries are silent.
    command -q starship ; and starship init fish | source
    command -q zoxide   ; and zoxide init fish | source
    command -q direnv   ; and direnv hook fish | source
    command -q fzf      ; and fzf --fish | source

    # eza as ls when installed
    if command -q eza
        alias ls 'eza'
        alias ll 'eza -la --git'
        alias lt 'eza --tree --level=2'
    end

    # Abbreviations — expand on space so you always see the real command
    abbr -a g git
    abbr -a lg lazygit
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
end
