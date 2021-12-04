#!/usr/bin/env bash

# First install additional dependencies if on macOS
MACHINE="$(uname -s)"
if [ "$MACHINE" == Darwin ]; then
  HOMEBREW_NO_AUTO_UPDATE=1 brew install diffutils
  HOMEBREW_NO_AUTO_UPDATE=1 brew install grep
fi

# Install dropboxignore command
rm -rf /usr/local/bin/dropboxignore
git clone https://github.com/sp1thas/dropboxignore.git
make -C dropboxignore install
rm -rf dropboxignore/
