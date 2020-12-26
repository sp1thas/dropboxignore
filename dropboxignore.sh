#!/bin/bash
# dropboxignore
# =============
# Ignore files and folders from dropbox using the .dropbox ignore files
#
# Copyright 2020 Panagiotis Simakis
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
IFS='
'
set -f
VERSION=0.0.12
VERBOSE=false
DROPBOX_IGNORE_FILE_NAME=".dropboxignore"
GIT_IGNORE_FILE_NAME=".gitignore"

# check input file or folder
function check_input() {
  if [ -d "$1" ]; then
    echo "Input folder: $1"
  elif [ -f "$1" ] || ( [ $(basename "$1") == "$DROPBOX_IGNORE_FILE_NAME" ] && [ -d $(dirname "$1") ] ); then
    echo "input file: $1"
  else
    echo "$1 does not exists"
    exit 2
  fi
}

# find all .gitignore files
function find_gitignore_files() {
  if [ -d "$1" ]; then
    GITIGNORE_FILES=$(find "${1}" -type f -name "${GIT_IGNORE_FILE_NAME}")
  else
    GITIGNORE_FILES=$(find "$(dirname "$1")" -maxdepth 1 -type f -name "${GIT_IGNORE_FILE_NAME}")
  fi
}

# delete all .dropboxignore files
function delete_dropboxignore_files() {
  if [ -d "$1" ]; then
    find "$1" -type f -name "$DROPBOX_IGNORE_FILE_NAME" -exec rm '{}' \;
  elif [ -f "$1" ]; then
    rm "$1"
  else
    echo "file not found"
    exit 3
  fi
}

# find all dropbox ignore files
function find_dropboxignore_files() {
  if [ -d "$1" ]; then
    DROPBOX_IGNORE_FILES=$(find "${1}" -type f -name "$DROPBOX_IGNORE_FILE_NAME")
  else
    DROPBOX_IGNORE_FILES=$(find "$(dirname "$1")" -maxdepth 1 -type f -name "$DROPBOX_IGNORE_FILE_NAME")
  fi
}

# generate a .dropbox ignore file based on .gitignore file
function generate_dropboxignore_file() {
  dropboxignore_file_path="$(dirname "${1}")/$DROPBOX_IGNORE_FILE_NAME"
  if [ -f "$dropboxignore_file_path" ]; then
    echo "♻️ $dropboxignore_file_path already exists"
  else
    tee "$dropboxignore_file_path" > /dev/null << EOF
# ----
# Automatically Generated .dropboxignore file at $(date)
# ----
$(cat "${1}")
# ----
EOF
    echo "✅ $dropboxignore_file_path created"
  fi
}

# update a .dropboxignore file base on changes on .gitignore file
function update_dropboxignore_file() {
  diff_content=$(diff --new-line-format="" --unchanged-line-format="" --ignore-blank-lines --ignore-tab-expansion --ignore-space-change --ignore-trailing-space -I "# [Automatically|-]" "${1}" "${2}")
  if [ ! -z "$diff_content" ]; then
    tee "${1}" > /dev/null << EOF
# Automatically updated .dropboxignore file at "$(date)"
# ----
$(echo "${diff_content}")
# ----
EOF
    echo "✅️ Updated ${2}"
  else
    echo "♻ No changes found: ${2}"
  fi
}

# update all .dropboxignore files
function update_dropboxignore_files() {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    dropboxignore_file="$(dirname "${gitignore_file}")/$DROPBOX_IGNORE_FILE_NAME"
    if [ -f "$dropboxignore_file" ]; then
      update_dropboxignore_file $gitignore_file $dropboxignore_file
    fi
  done
}

# generate .dropboxignore files
function generate_dropboxignore_files() {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    current_dir="$(dirname "${gitignore_file}")"
    dropboxignore_file="$(dirname "${gitignore_file}")/$DROPBOX_IGNORE_FILE_NAME"
    generate_dropboxignore_file "$gitignore_file"
  done
}

# ignore given file
function ignore_file() {
  attr -s com.dropbox.ignored -V 1 "$1"
}

# mark matched files as ignored
function ignore_files() {
  find_dropboxignore_files "${1}"
  for dropboxignore_file in $DROPBOX_IGNORE_FILES; do
    total_results=0
    for file_pattern in $(grep -v '^\s*$\|^\s*\#' "${dropboxignore_file}"); do
      file_pattern=${file_pattern%/}
      n_results=$(find $(dirname "${dropboxignore_file}") -iwholename ""${file_pattern}"" -printf '.' -exec attr -s com.dropbox.ignored -V 1 '{}' \; | wc -l)
      total_results=$((total_results+n_results))
    done
    echo "✅ Ignored files because of "${dropboxignore_file}": $total_results"
  done
}


function revert_ignored(){
  if [ $(getfattr --absolute-names -d -m "com\.dropbox\.ignored" "$1") ]; then
    attr -r com.dropbox.ignored "$1"
    echo "⚠️ Ignored file: $1 has been reverted"
  fi
}

# revert ignored files
function revert_ignored_files() {
  if [ -f "$1" ]; then
    echo "⚠️ Will revert "$1" only"
    revert_ignored "$1"
  else
    echo "⚠️ Will revert every ignored file or path in $1"
    for file_path in $(find "$1" -type f); do
      revert_ignored "$file_path"
    done
    for folder_path in $(find "$1" -type d); do
      revert_ignored "$folder_path"
    done
  fi
}

# print help message
display_help() {
  cat << EOF
Usage: dropboxignore command filename_or_folder

  Commands:

    generate            Generate .dropboxignore files based on existing .gitignore files.
                        If a .dropboxignore file already exists, will not be updated.
    update              Update existing .dropboxignore files if at least a .gitignore file have been changed. Provide an existing
                        .dropboxignore file or update everything by providing the dropbox folder.
    ignore              Ignore file or folder from dropbox. Related .dropboxignore file will be updated automatically.
    revert              Revert ignored file or folder.
    delete              Delete specific .dropboxignore file or every .dropboxignore files under the given directory.
    help                Will print this message and then will exit.
    version             Will print the version and then will exit.

EOF
}

PROGRAM_NAME="$(basename $0)"

case $1 in

  generate)
    generate_action=true
    ;;
  update)
    update_action=true
    ;;
  ignore)
    ignore_action=true
    ;;
  revert)
    revert_action=true
    ;;
  delete)
    delete_action=true
    ;;
  help)
    display_help
    exit 0
    ;;
  version)
    echo "$PROGRAM_NAME: $VERSION"
    exit 0
    ;;
  *)
    echo "$PROGRAM_NAME: '$1' is not a $PROGRAM_NAME command."
    echo "See '$PROGRAM_NAME help'"
    exit 1
    ;;
esac

# check input file or folder
check_input $2

input_file=$(realpath $2)

if [ "$generate_action" == true ]; then
  generate_dropboxignore_files "$input_file"
elif [ "$update_action" == true ]; then
  update_dropboxignore_files "$input_file"
elif [ "$ignore_action" == true ]; then
  ignore_files "$input_file"
elif [ "$delete_action" == true ]; then
  delete_dropboxignore_files "$input_file"
elif [ "$revert_action" == true ]; then
  revert_ignored_files "$input_file"
fi
