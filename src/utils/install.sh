#!/usr/bin/env bash

# First install additional dependencies if on macOS
MACHINE="$(uname -s)"

if [ "$MACHINE" == Darwin ]; then
  sudo -u "$SUDO_USER" HOMEBREW_NO_AUTO_UPDATE=1 brew install diffutils
  sudo -u "$SUDO_USER" HOMEBREW_NO_AUTO_UPDATE=1 brew install grep
fi

# Install dropboxignore command
rm -rf /usr/local/bin/dropboxignore
git clone https://github.com/sp1thas/dropboxignore.git
make -C dropboxignore install
rm -rf dropboxignore/


# a simple http request to count +1 request
INSTALL_COUNT_URL="https://kounter.tk/badge/dropboxignore"

if [ "$0" == c ]; then
  curl -s --request GET --url "${INSTALL_COUNT_URL}" > /dev/null
elif [ "$0" == w ]; then
  wget -q "${INSTALL_COUNT_URL}" -O /dev/null 2> /dev/null
fi
