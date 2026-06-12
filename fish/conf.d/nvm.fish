# nvm.fish integration
#
# Activates the active nvm node automatically. Two paths are supported:
#
#   1. The `nvm.fish` plugin by jorgebucaran (recommended for fish).
#      Install: `fisher install jorgebucaran/nvm.fish`
#      With the plugin installed, fish picks up .nvmrc automatically
#      and `nvm` works as a native fish command.
#
#   2. Plain nvm (bash) — falls back to prepending the default node's
#      bin directory to PATH so `node`/`npm` work in fish even without
#      the plugin. nvm itself still needs bash to switch versions.

if test -d "$HOME/.nvm"
    # If nvm.fish plugin is loaded, it sets up everything for us.
    if functions -q nvm
        # plugin already provides nvm — nothing to do
    else
        # Plugin not installed: surface the default node version's bin dir.
        set -l default_alias_file "$HOME/.nvm/alias/default"
        if test -f "$default_alias_file"
            set -l default_version (cat "$default_alias_file")
            # If it's a major like "24", resolve to the highest installed v24.*
            if test -d "$HOME/.nvm/versions/node/v$default_version"
                fish_add_path -g "$HOME/.nvm/versions/node/v$default_version/bin"
            else
                set -l resolved (ls "$HOME/.nvm/versions/node" 2>/dev/null | grep "^v$default_version" | sort -V | tail -n1)
                if test -n "$resolved"
                    fish_add_path -g "$HOME/.nvm/versions/node/$resolved/bin"
                end
            end
        end
    end
end
