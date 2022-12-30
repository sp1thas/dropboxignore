#!/bin/bash

#######################################
# Mark matched files as ignored.
# Globals:
#   DROPBOX_IGNORE_FILES
# Arguments:
#   Input folder.
# Outputs:
#   Number of ignored files.
#######################################
cmd_ignore() {
  if [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ]; then
    log_error "Cannot ignore an $DROPBOX_IGNORE_FILE_NAME. Choose another file or folder." 4
  elif [ -f "$1" ]; then
    ignore_file "$1"
  elif [ -d "$1" ]; then
    find_dropboxignore_files "$1"
    if [ -z "$DROPBOX_IGNORE_FILES" ]; then
      ignore_file "$1"
    else
        for dropboxignore_file in $DROPBOX_IGNORE_FILES; do
          file_total_results=0
          # shellcheck disable=SC2013
          if "$GREP_CMD" -q -P '^\s*!' "$dropboxignore_file"; then
            echo -e "$YELLOW$(get_relative_path "$dropboxignore_file" "$BASE_FOLDER") contains exception patterns, will be ignored"
            continue
          fi
          while read -r file_pattern; do
            file_pattern=${file_pattern%/}
            subdir="$(dirname "$file_pattern")"
            pattern="$(basename "$file_pattern")"
            n_results=0
            while read -r file_path; do
              ignore_file "$file_path"
              ((n_results++))
            done < <(find "$(dirname "$dropboxignore_file")/$subdir" -name "$pattern")
            file_total_results=$((file_total_results + n_results))
          done < <("$GREP_CMD" -v -P '^\s*$|^\s*\#|^\s*!' "$dropboxignore_file")
          log_debug "Matched files because of '$(get_relative_path "$dropboxignore_file" "$BASE_FOLDER")': $file_total_results"
        done
    fi
  fi
  echo -e "${BLUE}Total number of ignored files: $TOTAL_N_IGNORED_FILES $DEFAULT\nTotal number of ignored folders: $TOTAL_N_IGNORED_FOLDERS $DEFAULT"
}