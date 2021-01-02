#!/usr/bin/env bash

platform=$(uname -s)

case $platform in

  Linux)
    command0="sudo rm -rf /usr/local/bin/dropboxignore"
    command2="sudo wget -q https://raw.githubusercontent.com/sp1thas/dropboxignore/master/dropboxignore.sh -O /usr/local/bin/dropboxignore"
    command3="sudo chmod +x /usr/local/bin/dropboxignore"
    ;;
  Darwin)
    command0="rm -rf /usr/local/bin/dropboxignore"
    command2="wget -q https://raw.githubusercontent.com/sp1thas/dropboxignore/master/dropboxignore.sh -O /usr/local/bin/dropboxignore"
    command3="chmod +x /usr/local/bin/dropboxignore"
    ;;
  *)
    echo "Unsupported platform"
    exit 1
    ;;
esac


if [ -f /usr/local/bin/dropboxignore ]; then
  sh -c "$command0"
fi
sh -c "$command1"
sh -c "$command2"
sh -c "$command3"
dropboxignore help
