# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS and Linux (Ubuntu/Debian). The repository is a collection of shell config files plus an idempotent installer that links them into `$HOME` and provisions tooling (Homebrew/apt, Oh My Zsh, Starship, asdf, LunarVim).

## Commands

- `./install.sh` — full bootstrap. Detects the distro and runs the setup steps in order. Safe to re-run; every step skips work that is already done. Must be run from the repo root (scripts reference `$PWD`).
- `./dump_brewfile.sh` — regenerate `setup/macos/Brewfile` from the currently installed Homebrew packages (macOS only). Run this after installing/removing a brew package to keep the Brewfile in sync.
- `docker build -f docker/Dockerfile --build-arg BASE_IMAGE=ubuntu:22.04 . -t chatreejs/dotfiles:ubuntu` — build the containerized dotfiles image (the single `docker/Dockerfile` copies the repo in and runs `./install.sh`). Pass `--build-arg BASE_IMAGE=debian:12` for the Debian variant. The Jenkinsfile builds both in parallel and pushes to Docker Hub.
- `docker compose build && docker compose run --rm ubuntu` (or `debian`) — test harness for the installer. `docker-compose.yml` builds both variants from the one Dockerfile via `BASE_IMAGE`; the `dev`-profile `ubuntu-dev`/`debian-dev` services bind-mount the repo so you can re-run `./install.sh` without rebuilding.

There is no test suite, build step, or linter. `.editorconfig` defines formatting (4-space indent everywhere, **tab indent for `*.sh`**, LF, trailing-newline).

## Architecture

### Installer flow (`install.sh`)
`install.sh` is the orchestrator. It sources numbered scripts under `setup/` in sequence. The leading number encodes run order; scripts are gated on the detected distro:

- `setup/common/00-check-distro.sh` — the single source of truth for OS detection. It echoes `macos` or a Linux distro id (e.g. `ubuntu`, `debian`). Other scripts capture it via `DISTRO=$(source .../00-check-distro.sh)`. Reuse this rather than re-detecting.
- `setup/linux/` — apt-based essential packages (Linux only).
- `setup/macos/` — Homebrew install + `brew bundle` from `Brewfile` (macOS only).
- `setup/common/` — cross-platform: zsh, Oh My Zsh, Starship, asdf, LunarVim, then the two steps below.

### Two ways config reaches the shell
1. **Symlinking** (`setup/common/06-symlink-config.sh`): the `linking_dotfiles` helper symlinks tracked files into `$HOME`. If a real file already exists at the target it is moved to `*.bak` first; an existing symlink is replaced. Symlinked: `.zshenv`, `.gitconfig`, `.zsh/` (whole dir), `.config/starship.toml`, `.config/lvim/config.lua`. **To add a new dotfile, add a `linking_dotfiles` line here.**
2. **Prepending to `.zshrc`** (`setup/common/99-add-zsh-config.sh`): Oh My Zsh generates `~/.zshrc`, so this step idempotently prepends lines that set the asdf shims PATH and `source` the `~/.zsh/*.zsh` files. New top-level zsh entrypoints must be added to this list to load.

### Zsh layer (`.zsh/`)
- `omz.zsh` — Oh My Zsh config: theme (`robbyrussell`) and plugin list (asdf, git, z, autosuggestions, fast-syntax-highlighting, etc.).
- `aliases.zsh` — the aggregator: it `source`s the `utils/*.sh` files, then defines aliases (`k`→kubectl, `h`→helm, `vi`→lvim, …). New shell functions live in `utils/` and get pulled in here.
- `zsh-completions.zsh` — completion setup.
- `utils/` — function libraries grouped by topic: `kubernetes.sh` (`kn` namespace switch, `kc` context switch), `network.sh`, `backupfile.sh`, `include.sh`.

### Conventions
- Scripts are guarded to be idempotent (`command -v`, directory/symlink existence checks) and use emoji + `tput` color for status output.
- Pin tool versions explicitly and bump them at the top of the owning script: `asdf` release + `NODE_VERSION` in `04-setup-asdf.sh`, and `LV_BRANCH` + `NVIM_VERSION` in `05-setup-lunarvim.sh`. `05` tracks LunarVim's Nightly (`master`) on purpose — there is no stable LunarVim release for Neovim 0.11, which `copilot.lua` requires — and installs a pinned Neovim from GitHub releases on Linux (apt ships 0.6/0.7, too old). On macOS the Brewfile installs `neovim` with `link: false`, so `05` adds `$(brew --prefix neovim)/bin` to PATH itself.
- The `.editorconfig` declares `indent_style = tab` for `*.sh`, but every tracked script actually uses 4-space indent. Match the surrounding 4-space style when editing scripts.
