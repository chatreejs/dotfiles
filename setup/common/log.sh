#!/bin/bash

# Output helpers shared by every setup step; install.sh sources this first.
# Each step opens with log_step, then reports its results indented underneath:
#
#   ==> 🍺  Homebrew
#       ✅  Homebrew is already installed
_bold=$(tput bold 2>/dev/null)
_reset=$(tput sgr0 2>/dev/null)
_red=$(tput setaf 1 2>/dev/null)
_green=$(tput setaf 2 2>/dev/null)
_yellow=$(tput setaf 3 2>/dev/null)
_blue=$(tput setaf 4 2>/dev/null)

# Section header for a setup step
log_step() { echo; echo "${_blue}${_bold}==>${_reset} ${_bold}$1${_reset}"; }
# Work about to happen
log_info() { echo "    ➜   $1"; }
# Something was installed or changed
log_done() { echo "    ✨  ${_green}$1${_reset}"; }
# Already in the desired state, nothing to do
log_ok() { echo "    ✅  $1"; }
# Step intentionally not run on this machine
log_skip() { echo "    ⏩  ${_yellow}$1${_reset}"; }
# Something went wrong
log_error() { echo "    🚫  ${_red}$1${_reset}"; }

# Run a non-interactive command with its output indented under the current step.
# Keeps the command's exit status.
log_indent() {
    "$@" 2>&1 | sed 's/^/        /'
    return "${PIPESTATUS[0]}"
}
