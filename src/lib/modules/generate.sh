#!/bin/bash

#######################################
# Generate a .dropboxignore file based on .gitignore file.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
# Arguments:
#   .dropboxignore file path (even if not exists).
# Outputs:
#   Status about the generated file.
#######################################
generate_dropboxignore_file() {
  dropboxignore_file_path="$(dirname "$1")/$DROPBOX_IGNORE_FILE_NAME"
  if [ -f "$dropboxignore_file_path" ]; then
    log_debug "Already existing file: $(get_relative_path "$dropboxignore_file_path" "$BASE_FOLDER")"
  else
    tee "$dropboxignore_file_path" >/dev/null <<EOF
# ----
# Automatically Generated .dropboxignore file at $(date)
# ----
$(cat "${1}")
# ----
EOF
    log_info "Created file: $(get_relative_path "$dropboxignore_file_path" "$BASE_FOLDER")"
  fi
}
