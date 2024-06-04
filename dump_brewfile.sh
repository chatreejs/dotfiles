# Check Distro
DISTRO=$(source ${PWD}/setup/common/00-check-distro.sh)
OS=$(uname -s)

# Install Homebrew
if [[ $DISTRO == "macos" ]]; then
  if [[ ! -x "$(command -v brew)" ]]; then
    echo "No Homebrew found. Exiting..."
    exit 1
  fi
else
  echo "This script is only for macOS"
  exit 1
fi

brew bundle dump --cask --taps --brews --describe --force --file=${PWD}/setup/macos/Brewfile