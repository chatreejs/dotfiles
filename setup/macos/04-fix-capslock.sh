#!/bin/bash
set -euo pipefail

echo "🔧  $(tput setaf 6)Fixing Caps Lock language switch$(tput sgr0)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/bin/capslock-lang-switch.sh" install
