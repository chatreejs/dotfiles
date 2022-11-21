#!/bin/bash

setup_asdf() {
  if ! test -e ~/.asdf
  then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  else
    echo "✅ asdf is already installed (Skipping)"
  fi

  # HACK: add asdf to PATH!
  export PATH="$PATH:$HOME/.asdf/bin"

  if ! command -v asdf
  then
    echo "🚫 asdf binary is not found."
    return
  fi

  echo "📦 Updating asdf to latest stable version"
  asdf update

  for plugin in nodejs python dotnet
  do
    echo -e "🔌 adding $plugin plugin"
    asdf plugin add $plugin
  done
}

if command -v asdf &> /dev/null
then
  echo "✅ asdf is already installed (Skipping)"
else
  echo "🚀 Installing asdf"
  setup_asdf
  echo "✨ asdf installed"
fi