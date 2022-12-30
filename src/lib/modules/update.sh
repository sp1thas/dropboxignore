#!/bin/bash

#######################################
# uUpdate a .dropboxignore file based on changes on .gitignore file.
# Arguments:
#   dropboxingore file path to update.
# Outputs:
#   Update status.
#######################################
update_dropboxignore_file() {
  diff_content=$("$DIFF_CMD" --new-line-format="" --unchanged-line-format="" --ignore-blank-lines --ignore-tab-expansion --ignore-space-change --ignore-trailing-space -I "# [Automatically|-]" "${1}" "${2}")
  if [ -n "$diff_content" ]; then
    tee -a "$2" >/dev/null <<EOF
# Automatically updated .dropboxignore file at "$(date)"
# ----
$diff_content
# ----
EOF
    log_info "Updated $(get_relative_path "$2" "$BASE_FOLDER") $DEFAULT"
  else
    log_debug "No changes found: $(get_relative_path "$2" "$BASE_FOLDER")"
  fi
}