#!/bin/bash

#######################################
# List ignored files and folders.
# Arguments:
#   Input folder.
#   Filtering pattern
# Outputs:
#   Ignored files and folders
#######################################
cmd_list() {
  total_ignored_files=0
  total_ignored_folders=0
  if [ -z "$2" ]; then
    filtering_pattern='*'
  else
    filtering_pattern="$2"
  fi
  while read -r f_path; do
    file_ignore_status "$f_path"
    if [ -n "$FILE_ATTR_VALUE" ]; then
      get_relative_path "$f_path" "$BASE_FOLDER"
      if [ -f "$f_path" ]; then
        ((total_ignored_files++))
      elif [ -d "$f_path" ]; then
        ((total_ignored_folders++))
      fi
    fi
  done < <(find "$1" -name "$filtering_pattern")
  printf "%sTotal number of ignored files: %s\nTotal number of ignored folders: %s %s", "$YELLOW", "$total_ignored_files", "$total_ignored_folders", "$DEFAULT"
}
