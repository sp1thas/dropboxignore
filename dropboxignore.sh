#!/usr/bin/env bash
# dropboxignore
# =============
# Ignore files and folders from dropbox using the .dropbox ignore files
#
# MIT License
#
# Copyright (c) 2020 Panagiotis Simakis
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

IFS='
'
set -f
VERSION=0.0.15
DROPBOX_IGNORE_FILE_NAME=".dropboxignore"
GIT_IGNORE_FILE_NAME=".gitignore"
machine="$(uname -s)"
PROGRAM_NAME="$(basename "$0")"
VERBOSITY=1
TOTAL_N_IGNORED_FILES=0
TOTAL_N_REVERTED_FILES=0
TOTAL_N_GENERATED_FILES=0

#######################################
# Log info message.
# Globals:
#   VERBOSITY
# Arguments:
#   Info Message.
# Outputs:
#   Info Message
#######################################
function log_info() {
  if [ "$VERBOSITY" -ge 1 ]; then
    echo -e "$(date) [  INFO ] \e[32m$1\e[39m"
  fi
}
#######################################
# Log debug message.
# Globals:
#   VERBOSITY
# Arguments:
#   Debug Message.
# Outputs:
#   Debug Message
#######################################
function log_debug() {
  if [ "$VERBOSITY" -ge 2 ]; then
    echo -e "$(date) \e[34m[ DEBUG ] $1\e[39m"
  fi
}

#######################################
# Log error message.
# Globals:
#   VERBOSITY
# Arguments:
#   Error Message.
#   Exit status.
# Outputs:
#   Error message.
#######################################
function log_error() {
  if [ "$VERBOSITY" -ge 0 ]; then
    echo -e "$(date) \e[31m[ ERROR ] $1\e[39m"
  fi
  if [ -z "$2" ]; then
    exit 1
  else
    exit "$2"
  fi
}

#######################################
# Log warning message.
# Globals:
#   VERBOSITY
# Arguments:
#   Warning message.
# Outputs:
#   Warning message.
#######################################
function log_warning() {
  if [ "$VERBOSITY" -ge 1 ]; then
    echo -e "$(date) \e[31m[WARNING] $1\e[39m"
  fi
}

case $machine in
  Linux)
    machine="$machine"
    ;;
  Darwin)
    machine="MacOS"
    ;;
  *)
    log_error "$machine is not supported" 3
    ;;

esac

#######################################
# Check input file or folder.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
# Arguments:
#   Input file or folder.
# Outputs:
#   Input file/folder or error if not exists.
# Returns:
#   0 if file or folder exists, otherwise, returns 2.
#######################################
function check_input() {
  if [ -z "$1" ]; then
    log_error "You have to provide a file or folder" 2
  elif [ -d "$1" ]; then
    log_debug "Input folder: \"$1\""
  elif [ -f "$1" ] || { [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ] && [ -d "$(dirname "$1")" ] ; }; then
    log_debug "Input file: \"$1\""
  else
    log_error "\"$1\" does not exists" 2
  fi
}

#######################################
# Find all .gitignore files.
# Globals:
#   GIT_IGNORE_FILE_NAME
# Arguments:
#   Input file or folder.
#######################################
function find_gitignore_files() {
  if [ -d "$1" ]; then
    GITIGNORE_FILES=$(find "${1}" -type f -name "${GIT_IGNORE_FILE_NAME}")
  else
    GITIGNORE_FILES=$(find "$(dirname "$1")" -maxdepth 1 -type f -name "${GIT_IGNORE_FILE_NAME}")
  fi
}

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
function delete_dropboxignore_files() {
  if [ -d "$1" ]; then
    n_results=0
    while read -r file_path; do
      (( n_results++ ))
      rm "$file_path"
    done < <(find "$1" -type f -name "$DROPBOX_IGNORE_FILE_NAME")
    log_info "Deleted files: $n_results"
  elif [ -f "$1" ]; then
    if [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ]; then
      rm "$1"
      log_info "Removed file: \"$1\""
    else
      log_error "Given file is not a $DROPBOX_IGNORE_FILE_NAME file."
    fi
  else
    log_error "file not found" 3
    exit 3
  fi
}

#######################################
# Find all .dropboxignore files.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
#   DROPBOX_IGNORE_FILES
# Arguments:
#   Input folder or file.
#######################################
function find_dropboxignore_files() {
  if [ -d "$1" ]; then
    DROPBOX_IGNORE_FILES=$(find "${1}" -type f -name "$DROPBOX_IGNORE_FILE_NAME")
  else
    DROPBOX_IGNORE_FILES=$(find "$(dirname "$1")" -maxdepth 1 -type f -name "$DROPBOX_IGNORE_FILE_NAME")
  fi
}

#######################################
# Generate a .dropboxignore file based on .gitignore file.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
# Arguments:
#   .dropboxignore file path (even if not exists).
# Outputs:
#   Status about the generated file.
#######################################
function generate_dropboxignore_file() {
  dropboxignore_file_path="$(dirname "${1}")/$DROPBOX_IGNORE_FILE_NAME"
  if [ -f "$dropboxignore_file_path" ]; then
    log_debug "Already existing file: $dropboxignore_file_path"
  else
    tee "$dropboxignore_file_path" > /dev/null << EOF
# ----
# Automatically Generated .dropboxignore file at $(date)
# ----
$(cat "${1}")
# ----
EOF
    log_info "Created file: $dropboxignore_file_path"
  fi
}

#######################################
# uUpdate a .dropboxignore file based on changes on .gitignore file.
# Arguments:
#   .dropboxingore file path to update.
# Outputs:
#   Update status.
#######################################
function update_dropboxignore_file() {
  diff_content=$(diff --new-line-format="" --unchanged-line-format="" --ignore-blank-lines --ignore-tab-expansion --ignore-space-change --ignore-trailing-space -I "# [Automatically|-]" "${1}" "${2}")
  if [ -n "$diff_content" ]; then
    tee "${1}" > /dev/null << EOF
# Automatically updated .dropboxignore file at "$(date)"
# ----
${diff_content}
# ----
EOF
    log_info "Updated $2"
  else
    log_debug "No changes found: $2"
  fi
}

#######################################
# Update all .dropboxignore files.
# Globals:
#   GITIGNORE_FILES
#   DROPBOX_IGNORE_FILE_NAME
# Arguments:
#   Input folder.
#######################################
function update_dropboxignore_files() {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    dropboxignore_file="$(dirname "${gitignore_file}")/$DROPBOX_IGNORE_FILE_NAME"
    if [ -f "$dropboxignore_file" ]; then
      update_dropboxignore_file "$gitignore_file" "$dropboxignore_file"
    fi
  done
}

#######################################
# Generate all .dropboxignore files.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
#   GITIGNORE_FILES
# Arguments:
#   Input folder.
#######################################
function generate_dropboxignore_files() {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    current_dir="$(dirname "${gitignore_file}")"
    dropboxignore_file="$current_dir/$DROPBOX_IGNORE_FILE_NAME"
    if [ -f "$dropboxignore_file" ]; then
      log_debug "Already existing file: \"$dropboxignore_file\""
    else
      generate_dropboxignore_file "$gitignore_file"
      (( TOTAL_N_GENERATED_FILES++ ))
    fi
  done
  log_info "Total number of generated files: $TOTAL_N_GENERATED_FILES"
}

#######################################
# Ignore file.
# Globals:
#   I
# Arguments:
#   Input file.
#######################################
function ignore_file() {
  attr_value="$(getfattr --absolute-names -d -m "com\.dropbox\.ignored" "$1")"
  if [  -z "$attr_value" ] || [ "$attr_value" == 0 ]; then
    case $machine in
      Linux)
        attr -s com.dropbox.ignored -V 1 "$1" > /dev/null
        (( TOTAL_N_IGNORED_FILES++ ))
        ;;
      MacOS)
        xattr -w com.dropbox.ignored 1 "$1" > /dev/null
        (( TOTAL_N_IGNORED_FILES++ ))
        ;;
    esac
    log_debug "Ignored file: \"$1\""
  else
    log_debug "Already ignored file: \"$1\""
  fi
}

#######################################
# Mark matched files as ignored.
# Globals:
#   DROPBOX_IGNORE_FILES
# Arguments:
#   Input folder.
# Outputs:
#   Number of ignored files.
#######################################
function ignore_files() {
  find_dropboxignore_files "${1}"
  if [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ]; then
    log_error "Cannot ignore an $DROPBOX_IGNORE_FILE_NAME. Choose another file or folder." 4
  elif [ -f "$1" ]; then
    ignore_file "$1"
  else
    for dropboxignore_file in $DROPBOX_IGNORE_FILES; do
      file_total_results=0
      # shellcheck disable=SC2013
      for file_pattern in $(grep -v '^\s*$\|^\s*\#|^!' "$dropboxignore_file"); do
        file_pattern=${file_pattern%/}
        subdir="$(dirname "$file_pattern")"
        pattern="$(basename "$file_pattern")"
        n_results=0
        while read -r file_path; do
          ignore_file "$file_path"
          (( n_results++ ))
        done < <(find "$(dirname "${dropboxignore_file}")/$subdir" -name "$pattern")
        file_total_results=$((file_total_results+n_results))
      done
      # shellcheck disable=SC2013
      for file_pattern in $(grep '^!' "$dropboxignore_file"); do
        file_pattern=${file_pattern%/}
        file_pattern="${file_pattern:1:${#file_pattern}}"
        subdir="$(dirname "$file_pattern")"
        pattern="$(basename "$file_pattern")"
        while read -r file_path; do
          revert_ignored "$file_path"
        done < <(find "$(dirname "${dropboxignore_file}")/$subdir" -name "$pattern")
      done
      log_debug "Matched files because of '${dropboxignore_file}': $file_total_results"
    done
    log_info "Total number of ignored files: $TOTAL_N_IGNORED_FILES"
  fi
}
#######################################
# List ignored files and folders.
# Arguments:
#   Input folder.
#   Filtering pattern
# Outputs:
#   Ignored files and folders
#######################################
function list_ignored() {
  total_ignored_files=0
  total_ignored_folders=0
  if [ -z "$2" ]; then
    filtering_pattern='*'
  else
    filtering_pattern="$2"
  fi
  while read -r f_path; do
    attr_value="$(getfattr --absolute-names -d -m "com\.dropbox\.ignored" "$f_path")"
    if [ -n "$attr_value" ]; then
      if [ -f "$f_path" ]; then
        log_info "File: $f_path"
        (( total_ignored_files++ ))
      elif [ -d "$f_path" ]; then
        log_info "Folder: $f_path"
        (( total_ignored_folders++ ))
      fi
    fi
  done < <(find "$1" -name "$filtering_pattern")
  log_info "Total number of ignored files: $total_ignored_files"
  log_info "Total number of ignored folders: $total_ignored_folders"
}


#######################################
# Revert ignored file.
# Arguments:
#   Input file.
# Outputs:
#   Message about the reverted file.
#######################################
function revert_ignored(){
  if [ "$(getfattr --absolute-names -d -m "com\.dropbox\.ignored" "$1")" ]; then
    attr -r com.dropbox.ignored "$1" > /dev/null
    log_debug "Reverted file: \"$1\""
    (( TOTAL_N_REVERTED_FILES++ ))
  else
    log_debug "Already reverted file: \"$1\""
  fi
}

#######################################
# Revert all ignored files.
# Arguments:
#   Input folder.
# Outputs:
#   Message about reverted files.
#######################################
function revert_ignored_files() {
  if [ -f "$1" ]; then
    revert_ignored "$1"
  else
    while read -r file_path; do
      if [ "$(getfattr --absolute-names -d -m "com\.dropbox\.ignored" "$file_path")" ]; then
        revert_ignored "$file_path"
      fi
    done < <(find "$1" -type f)
    log_info "Number of reverted files: $TOTAL_N_REVERTED_FILES"
    TOTAL_N_REVERTED_FILES=0
    while read -r file_path; do
      if [ "$(getfattr --absolute-names -d -m "com\.dropbox\.ignored" "$file_path")" ]; then
        revert_ignored "$file_path"
        (( n_results++ ))
      fi
    done < <(find "$1" -type d)
    log_info "number of reverted folders: $TOTAL_N_REVERTED_FILES"
  fi
}

#######################################
# Print help message.
# Outputs:
#   help message
#######################################
display_help() {
  cat << EOUSAGE
Usage: "$PROGRAM_NAME" <command> <file_or_folder> [-v 0-2]

  Commands:

    generate            Generate .dropboxignore files based on existing .gitignore files.
                        If a .dropboxignore file already exists, will not be updated.
    update              Update existing .dropboxignore files if at least one .gitignore file have been changed.
    ignore              Ignore file or folder from dropbox.
    revert              Revert ignored file or folder.
    delete              Delete specific .dropboxignore file or every .dropboxignore files under the given directory.
    help                Will print this message and then will exit.
    version             Will print the version and then will exit.
    list                List ignored files and folders

  Options:
    -v                  Choose verbose level (0: Error, 1: Info, 2: Debug)
    -p                  Filtering pattern

EOUSAGE
}

case $1 in

  "")
    echo "You have to specify an action."
    echo "See '$PROGRAM_NAME help'"
    exit 3
    ;;
  generate)
    generate_action=true
    shift
    ;;
  update)
    update_action=true
    shift
    ;;
  ignore)
    ignore_action=true
    shift
    ;;
  revert)
    revert_action=true
    shift
    ;;
  delete)
    delete_action=true
    shift
    ;;
  help)
    display_help
    exit 0
    ;;
  version)
    echo "$PROGRAM_NAME: $VERSION"
    exit 0
    ;;
  list)
    list_action=true
    shift
    ;;
  *)
    echo "$PROGRAM_NAME: '$1' is not a $PROGRAM_NAME command."
    echo "See '$PROGRAM_NAME help'"
    exit 1
    ;;
esac

input_f="$1"

shift

while getopts ':vp:' opt; do
  case "$opt" in
    v) VERBOSITY="$OPTARG"
       ;;
    p)
      FILTERING_PATTERN="$OPTARG"
      ;;
    \?)
      echo "Unknown option: -$OPTARG"
      exit 3
      ;;
  esac
done

log_debug "Operating system: $machine"

# check input file or folder
check_input "$input_f"

input_f=$(realpath "$input_f")

# run action
if [ "$generate_action" == true ]; then
  generate_dropboxignore_files "$input_f"
elif [ "$update_action" == true ]; then
  update_dropboxignore_files "$input_f"
elif [ "$ignore_action" == true ]; then
  ignore_files "$input_f"
elif [ "$delete_action" == true ]; then
  delete_dropboxignore_files "$input_f"
elif [ "$revert_action" == true ]; then
  revert_ignored_files "$input_f"
elif [ "$list_action" == true ]; then
  list_ignored "$input_f" "$FILTERING_PATTERN"
fi
