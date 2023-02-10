#!/bin/bash

#######################################
# Revert ignored file.
# Arguments:
#   Input file.
# Outputs:
#   Message about the reverted file.
#######################################
revert_ignored() {
  file_ignore_status "$1"
  if [ "$FILE_ATTR_VALUE" == 1 ]; then
    case $MACHINE in
    Linux)
      attr -r "$FILE_ATTR_NAME" "$1" >/dev/null
      ;;
    Darwin)
      xattr -d "$FILE_ATTR_NAME" "$1" >/dev/null
      ;;
    esac

    log_debug "Reverted file: $(get_relative_path "$1" "$BASE_FOLDER")"
    ((TOTAL_N_REVERTED_FILES++))
  else
    log_debug "Already reverted file: $(get_relative_path "$1" "$BASE_FOLDER")"
  fi
}
