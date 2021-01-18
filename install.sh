#!/usr/bin/env bash
rm -rf /usr/local/bin/dropboxignore
wget -q https://raw.githubusercontent.com/sp1thas/dropboxignore/master/dropboxignore.sh -O /usr/local/bin/dropboxignore
chmod +x /usr/local/bin/dropboxignore
echo "dropboxignore has been installed."