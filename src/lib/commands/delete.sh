#!/bin/bash

#######################################
# Delete all .dropboxignore files
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
# Arguments:
#   Input folder.
# Outputs:
#   Warning message if file not found.
# Returns:
#   3 if file not found, otherwise, 0.
#######################################
cmd_delete() {
  if [ -d "$1" ]; then
    n_results=0
    while read -r file_path; do
      ((n_results++))
      rm "$file_path"
    done < <(find "$1" -type f -name "$DROPBOX_IGNORE_FILE_NAME")
    echo -e "$YELLOW Deleted files: $n_results $DEFAULT"
  elif [ -f "$1" ]; then
    if [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ]; then
      rm "$1"
      echo -e "$YELLOW Removed file: $(get_relative_path "$1" "$BASE_FOLDER") $DEFAULT"
    else
      log_error "Given file is not a $DROPBOX_IGNORE_FILE_NAME file."
    fi
  else
    log_error "file not found" 3
  fi
}
