#!/bin/bash

#######################################
# Update all .dropboxignore files.
# Globals:
#   GITIGNORE_FILES
#   DROPBOX_IGNORE_FILE_NAME
# Arguments:
#   Input folder.
#######################################
cmd_update() {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    dropboxignore_file="$(dirname "$gitignore_file")/$DROPBOX_IGNORE_FILE_NAME"
    if [ -f "$dropboxignore_file" ]; then
      update_dropboxignore_file "$gitignore_file" "$dropboxignore_file"
    fi
  done
}