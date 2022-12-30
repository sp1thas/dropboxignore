#!/bin/bash

#######################################
# Generate all .dropboxignore files.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
#   GITIGNORE_FILES
# Arguments:
#   Input folder.
#######################################
cmd_generate() {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    if "$GREP_CMD" -q -P '^\s*!' "$gitignore_file"; then
      echo -e "$YELLOW$(get_relative_path "$gitignore_file" "$BASE_FOLDER") contains exception patterns, will be ignored"
      continue
    fi
    current_dir="$(dirname "$gitignore_file")"
    dropboxignore_file="$current_dir/$DROPBOX_IGNORE_FILE_NAME"
    if [ -f "$dropboxignore_file" ]; then
      log_debug "Already existing file: $(get_relative_path "$dropboxignore_file" "$BASE_FOLDER")"
    else
      generate_dropboxignore_file "$gitignore_file"
      ((TOTAL_N_GENERATED_FILES++))
    fi
  done
  echo -e "${YELLOW}Total number of generated files: $TOTAL_N_GENERATED_FILES $DEFAULT"
}