#!/usr/bin/env bash

if [ -f /usr/local/bin/dropboxignore ]; then
  sudo rm /usr/local/bin/dropboxignore
fi
sudo wget -q https://raw.githubusercontent.com/sp1thas/dropboxignore/master/dropboxignore.sh -O /usr/local/bin/dropboxignore
sudo chmod +x /usr/local/bin/dropboxignore
dropboxignore help

