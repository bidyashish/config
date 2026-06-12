# git cheatsheet

Opinionated defaults + a small set of aliases. The goal: fewer footguns, less typing.

## Files

- `gitconfig` → `~/.gitconfig`
- `gitignore_global` → `~/.config/git/ignore` (referenced by `core.excludesfile`)

## Defaults in this config (and why)

| Setting                        | Effect                                                            |
| ------------------------------ | ----------------------------------------------------------------- |
| `pull.rebase = true`           | `git pull` rebases instead of merging — no "merge branch main" noise |
| `push.autoSetupRemote = true`  | First `git push` on a new branch sets upstream automatically       |
| `push.followTags = true`       | `git push` also pushes annotated tags                              |
| `init.defaultBranch = main`    | New repos use `main`                                               |
| `fetch.prune = true`           | `git fetch` drops remote-tracking branches that no longer exist    |
| `rebase.autoStash = true`      | Stash dirty changes before rebase, pop after                       |
| `rebase.autoSquash = true`     | `fixup!` / `squash!` commits combine on rebase                     |
| `merge.conflictStyle = zdiff3` | Conflict markers also show the common ancestor — easier resolves   |
| `rerere.enabled = true`        | Remember conflict resolutions and replay them next time            |
| `diff.algorithm = histogram`   | Better diffs on moved/refactored code                              |
| `branch.sort = -committerdate` | `git branch` lists most-recently-touched branches first            |
| `tag.sort = version:refname`   | Tags sort as versions (`v10` after `v9`, not before `v2`)          |
| `commit.verbose = true`        | Commit editor shows the staged diff below the message              |
| `help.autocorrect = prompt`    | Typo'd commands suggest the fix and ask before running             |

No `core.editor` is set — git uses `$EDITOR`, which fish exports as `nvim` (or `vim` when nvim isn't installed).

## Aliases

```sh
git st            # status -sb (short + branch info)
git co <ref>      # checkout
git br            # branch
git ci            # commit
git cm "msg"      # commit -m
git last          # show last commit + files changed
git lg            # pretty graph log
git undo          # reset --soft HEAD~1 — undo last commit, keep changes staged
git unstage <f>   # restore --staged <f>
git amend         # amend the previous commit, keep its message
git pushf         # push --force-with-lease (safer than --force)
git wip           # add -A && commit -m 'wip'
git root          # absolute path to repo root
git cleanup       # delete local branches already merged into main
```

## Recipes you'll use weekly

**Rewrite the last commit:**

```sh
# changed your mind about something you just committed
git add <fixed-file>
git amend            # alias above — keeps the original message
git pushf            # only if you'd already pushed
```

**Squash a bunch of commits before merging:**

```sh
git rebase -i origin/main
# mark commits as 'squash' or 'fixup' in the editor
```

**Quick stash & resume:**

```sh
git stash push -m "wip-thoughts"
git stash list
git stash pop       # apply + drop
git stash apply     # apply, keep on stack
```

**Find what introduced a bug:**

```sh
git log -S"some_string"        # commits that added/removed this string
git log -p path/to/file        # full history of one file
git bisect start
git bisect bad
git bisect good <known-good-ref>
# git will check out commits to test — mark each `good` or `bad`
git bisect reset
```

**Forgot which branch you were on:**

```sh
git reflog          # everything HEAD has ever pointed at, with timestamps
git checkout HEAD@{2}
```

**Undo a bad push (carefully):**

```sh
git reset --hard <good-ref>
git pushf           # force-with-lease — refuses if someone else pushed in the meantime
```

## Global ignore

`gitignore_global` covers `.DS_Store`, `node_modules`, `.venv`, `target/`, `.env`, common editor artefacts. Per-repo `.gitignore` still wins; this is just a baseline so you don't have to add the same 10 lines to every repo.

## When git is angry

```sh
git status                              # always start here
git log --oneline -20                   # what are the recent commits
git diff                                # what's changed but not staged
git diff --staged                       # what's staged but not committed
git ls-files --others --exclude-standard # untracked files (respects .gitignore)
```
