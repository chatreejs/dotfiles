#!/bin/bash

setup_asdf() {
  if ! test -e ~/.asdf
  then
    git clone https://github.com/asdf-vm/asdf.git --branch v0.16.0 ~/.asdf
  else
    echo "✅  $(tput setaf 3)asdf is already installed (Skipping)$(tput sgr0)"
  fi

  # HACK: add asdf to PATH!
  export PATH="$PATH:$HOME/.asdf/bin"

  if ! command -v asdf
  then
    echo "🚫  $(tput setaf 1)asdf binary is not found.$(tput sgr0)"
    return
  fi

  echo "📦  Updating asdf to latest stable version"
  asdf update

  for plugin in nodejs python
  do
    echo -e "🔌  adding $plugin plugin"
    asdf plugin add $plugin
  done
}

if command -v asdf &> /dev/null
then
  echo "✅  $(tput setaf 3)asdf is already installed (Skipping)$(tput sgr0)"
else
  echo "🚀  Installing asdf"
  setup_asdf
  echo "✨  $(tput setaf 2)asdf installed$(tput sgr0)"
fi