#!/bin/bash

#######################################
# Ignore file.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
#   BASE_FOLDER
# Arguments:
#   Input file.
#######################################
ignore_file() {
  file_ignore_status "$1"
  if [ -z "$FILE_ATTR_VALUE" ]; then
    if [ -f "$1" ]; then
      ((TOTAL_N_IGNORED_FILES++))
    else
      ((TOTAL_N_IGNORED_FOLDERS++))
    fi
    case $MACHINE in
    Linux)
      attr -s "$FILE_ATTR_NAME" -V 1 "$1" >/dev/null
      ;;
    Darwin)
      xattr -w "$FILE_ATTR_NAME" 1 "$1" >/dev/null
      ;;
    esac
    log_debug "Ignored file: $(get_relative_path "$1" "$BASE_FOLDER")"
  else
    log_debug "Already ignored file: $(get_relative_path "$1" "$BASE_FOLDER")"
  fi
}

#######################################
# Get file status.
# Globals:
#   FILE_ATTR_VALUE
#   FILE_ATTR_NAME
# Arguments:
#   Input file.
#######################################
file_ignore_status() {
  unset FILE_ATTR_VALUE
  case $MACHINE in
  Linux)
    FILE_ATTR_VALUE="$(getfattr --absolute-names --only-values -m "$FILE_ATTR_NAME" "$1")"
    ;;
  Darwin)
    FILE_ATTR_VALUE="$(xattr -p "$FILE_ATTR_NAME" "$1" 2>/dev/null)"
    ;;
  esac
}
