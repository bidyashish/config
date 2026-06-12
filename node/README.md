# node version

Node is managed via [nvm](https://github.com/nvm-sh/nvm), not Homebrew, so you can switch versions per project.

## Files

- `default-version` — the node major version this machine should default to (currently `24`)

## First-time setup

```sh
# 1. install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# 2. install + alias the default version pinned in this repo
NODE_VERSION=$(cat default-version)
bash -c "source ~/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION"
```

After this, `~/.nvm/alias/default` contains `24` (or whatever you pinned), and `fish/conf.d/nvm.fish` will put that version on `PATH` automatically in new shells.

## Native fish integration (optional but recommended)

Vanilla nvm is bash-only. To switch node versions from fish without `bash -c`, install the [`nvm.fish`](https://github.com/jorgebucaran/nvm.fish) plugin via [fisher](https://github.com/jorgebucaran/fisher):

```sh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | fish -c 'source && fisher install jorgebucaran/fisher jorgebucaran/nvm.fish'
```

Now in fish:

```fish
nvm install 22         # install node 22
nvm use 22             # switch this shell to 22
nvm list               # what's installed
nvm current            # what's active
```

It also auto-picks the version listed in `.nvmrc` when you `cd` into a repo.

## Day-to-day

```sh
nvm install 20.11.0    # specific version
nvm install --lts      # latest LTS
nvm use <version>      # switch shells
nvm alias default 22   # change the global default
nvm uninstall 18       # free disk space

# per-project
echo "22" > .nvmrc     # commit alongside package.json
nvm use                # reads .nvmrc
```

## Updating the pin in this repo

When you decide a new major is the new baseline:

```sh
echo "26" > default-version
# also bump it on this machine
nvm install 26 && nvm alias default 26
```

Commit the change.
