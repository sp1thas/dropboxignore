#!/bin/bash

#######################################
# Revert all ignored files.
# Arguments:
#   Input folder.
# Outputs:
#   Message about reverted files.
#######################################
cmd_revert() {
  if [ -f "$1" ]; then
    revert_ignored "$1"
  else
    while read -r file_path; do
      file_ignore_status "$file_path"
      if [ "$FILE_ATTR_VALUE" == 1 ]; then
        revert_ignored "$file_path"
      fi
    done < <(find "$1" -type f)
    printf "%s↩️ Total number of reverted files: %s %s", "$BLUE", "$TOTAL_N_REVERTED_FILES", "$DEFAULT"
    TOTAL_N_REVERTED_FILES=0
    while read -r file_path; do
      file_ignore_status "$file_path"
      if [ "$FILE_ATTR_VALUE" == 1 ]; then
        revert_ignored "$file_path"
        ((n_results++))
      fi
    done < <(find "$1" -type d)
    printf "%s📁 Total number of reverted folders: %s %s", "$BLUE", "$TOTAL_N_REVERTED_FILES", "$DEFAULT"
  fi
}
