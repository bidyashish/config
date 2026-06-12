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

    # fzf searches via fd when installed: respects .gitignore, finds hidden files
    if command -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git'
    end
    # bat preview in the Ctrl+T file picker
    command -q bat ; and set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --line-range :200 {}'"

    # eza as ls when installed
    if command -q eza
        alias ls 'eza'
        alias ll 'eza -la --git'
        alias lt 'eza --tree --level=2'
    end

    # bat as cat when installed (--paging=never keeps it cat-like)
    command -q bat ; and alias cat 'bat --paging=never'

    # Abbreviations — expand on space so you always see the real command
    abbr -a g git
    abbr -a lg lazygit
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
end
