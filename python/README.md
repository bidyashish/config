# Python cheatsheet

The recommended Python workflow on this machine: **[uv](https://docs.astral.sh/uv/) for everything project-related**, **[pipx](https://pipx.pypa.io/) for global CLI tools**, **brew Python as a system fallback**.

## Files

- `default-version` — Python version this setup pins (currently `3.13`)

## Why uv

uv replaces `pip`, `virtualenv`, `pyenv`, `pip-tools`, and `poetry` with one binary. It's 10–100× faster, written in Rust, by the same team as `ruff`.

| Old way                                  | uv way                              |
| ---------------------------------------- | ----------------------------------- |
| `pyenv install 3.13 && pyenv local 3.13` | `uv python install 3.13`            |
| `python -m venv .venv && source .venv/bin/activate` | `uv venv` (auto-activated by `uv run`) |
| `pip install requests`                   | `uv add requests` (in a project)    |
| `pip install -r requirements.txt`        | `uv sync`                           |
| `python script.py`                       | `uv run script.py`                  |
| `pip-compile`                            | `uv lock`                           |

You rarely need to activate the venv manually — `uv run <cmd>` does the right thing inside any project.

## First-time setup

`uv` is already in the Brewfile, so `brew bundle` installs it. After that:

```sh
# install the pinned Python version managed by uv (independent of brew)
uv python install $(cat default-version)

# verify
uv python list
```

## Starting a new project

```sh
mkdir myproj && cd myproj
uv init                      # creates pyproject.toml, .python-version, README, sample main.py
uv add requests              # add a runtime dep — also creates uv.lock
uv add --dev pytest ruff     # dev-only deps
uv run python main.py        # runs in the project venv
uv run pytest                # runs pytest from the dev deps
```

That's it — no `pip install`, no `source .venv/bin/activate`, no `requirements.txt`. The `pyproject.toml` + `uv.lock` are what you commit.

## Working in an existing uv project

```sh
git clone <repo> && cd <repo>
uv sync                      # creates .venv from uv.lock — reproducible
uv run pytest                # or whatever the project's entry is
```

## Plain virtualenv (no project, just an env)

When you just need a scratch env (e.g. one-off scripts, jupyter):

```sh
uv venv                       # creates .venv/ using the default Python
uv venv --python 3.12         # specific version
uv pip install jupyterlab     # uses the .venv automatically
source .venv/bin/activate.fish  # only if you want to drop into it
# ... or just `uv run jupyter lab`
```

`uv pip` is a drop-in replacement for `pip` that's much faster — it doesn't require activating the venv.

## Running scripts with inline deps (PEP 723)

For one-file scripts, uv supports inline metadata so you don't even need a project:

```py
# /// script
# requires-python = ">=3.13"
# dependencies = ["httpx", "rich"]
# ///
import httpx
from rich import print
print(httpx.get("https://example.com").status_code)
```

```sh
uv run script.py     # uv reads the header, builds an ephemeral env, runs it
```

## Global CLI tools — pipx (or `uv tool`)

For CLIs you want on `PATH` everywhere (`black`, `ruff`, `httpie`, `awscli`, etc.):

```sh
# either of these works — pipx is the standard, `uv tool` is faster
pipx install black
pipx list
pipx upgrade-all

uv tool install ruff          # uv's equivalent — installs into ~/.local/share/uv/tools
uv tool list
uv tool upgrade --all
```

Choose one and stick with it per tool. `uv tool` is faster but pipx has wider muscle memory.

## System Python (brew)

`brew python@3.13` is installed mainly so `/opt/homebrew/bin/python3` always exists for ad-hoc shell scripts, system tooling, and bootstrap tasks. **Don't `pip install` into it** — that route eventually breaks. Use `uv venv` or `pipx` instead.

```sh
python3 --version            # what brew gives you
which python3                # /opt/homebrew/bin/python3
```

## Updating the pinned version

```sh
echo "3.14" > default-version    # whenever you want to bump
uv python install 3.14
```

Per-project pins live in each repo's `.python-version` file, written by `uv init` (or `uv python pin 3.13`).

## Quality tools worth knowing

| Tool        | Purpose                                | Install                |
| ----------- | -------------------------------------- | ---------------------- |
| `ruff`      | linter + formatter (replaces flake8, isort, black) | `uv add --dev ruff`  |
| `pytest`    | test runner                            | `uv add --dev pytest`  |
| `mypy` / `pyright` | type checking                   | `uv add --dev mypy`    |
| `pre-commit`| run linters on commit                  | `uv tool install pre-commit` |

A minimal `pyproject.toml` for a new project:

```toml
[project]
name = "myproj"
version = "0.1.0"
requires-python = ">=3.13"
dependencies = []

[tool.ruff]
line-length = 100

[tool.pytest.ini_options]
addopts = "-ra"
testpaths = ["tests"]
```

## Quick reference

```sh
uv init                       # new project here
uv add <pkg>                  # add runtime dep
uv add --dev <pkg>            # add dev dep
uv remove <pkg>               # remove dep
uv sync                       # install everything from uv.lock
uv lock                       # update uv.lock without installing
uv run <cmd>                  # run cmd in the project venv
uv python install <version>   # install a Python version
uv python pin <version>       # pin this project to a version
uv tool install <cli>         # global CLI tool
uv cache clean                # free disk space
```
