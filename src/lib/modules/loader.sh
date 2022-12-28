#!/bin/bash

#######################################
# Source sub-commands scripts.
# Arguments:
#   CLI directory.
#######################################
source_subcommands(){
  for subfolder in "modules" "commands";
  do
    for f in $( find "$1/$subfolder" -type f \( -name "*.sh" -and -not -name "loader.sh" \) | sort -n );
    do
      source "$f"
    done
  done
}

source_subcommands "$1"