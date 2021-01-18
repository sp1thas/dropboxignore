#!/usr/bin/env bash
# dropboxignore
# =============
# Ignore files and folders from dropbox using the .dropbox ignore files

IFS='
'
set -f
if [ -f "$(dirname "$0")/VERSION.txt" ]; then
  VERSION="$(cat "$(dirname "$0")/VERSION.txt")"
else
  VERSION="$(cat "/usr/local/share/dropboxignore/VERSION.txt")"
fi
DROPBOX_IGNORE_FILE_NAME=".dropboxignore"
GIT_IGNORE_FILE_NAME=".gitignore"
MACHINE="$(uname -s)"
PROGRAM_NAME="$(basename "$0")"
VERBOSITY=1
TOTAL_N_IGNORED_FILES=0
TOTAL_N_REVERTED_FILES=0
TOTAL_N_GENERATED_FILES=0
BASE_FOLDER="$PWD"
FILE_ATTR_NAME="com.dropbox.ignored"

DEFAULT="\e[0m"
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
YELLOW="\e[33m"

#######################################
# Log info message.
# Globals:
#   VERBOSITY
# Arguments:
#   Info Message.
# Outputs:
#   Info Message
#######################################
log_info () {
  if [ "$VERBOSITY" -ge 1 ]; then
    echo -e "$(date) $GREEN [  INFO ] $1 $DEFAULT"
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
log_debug () {
  if [ "$VERBOSITY" -ge 2 ]; then
    echo -e "$(date) $BLUE [ DEBUG ] $1 $DEFAULT"
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
log_error () {
  if [ "$VERBOSITY" -ge 0 ]; then
    echo -e "$(date) $RED [ ERROR ] $1 $DEFAULT"
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
log_warning () {
  if [ "$VERBOSITY" -ge 1 ]; then
    echo -e "$(date) $YELLOW [WARNING] $1 $DEFAULT"
  fi
}

case $MACHINE in
  Linux)
    ;;
  Darwin)
    MACHINE="MacOS"
    ;;
  *)
    log_error "$MACHINE is not supported" 3
    ;;

esac

#######################################
# Check input file or folder.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
#   BASE_FOLDER
# Arguments:
#   Input file or folder.
# Outputs:
#   Input file/folder or error if not exists.
# Returns:
#   0 if file or folder exists, otherwise, returns 2.
#######################################
check_input () {
  if [ -z "$1" ]; then
    log_error "You have to provide a file or folder" 2
  elif [ -d "$1" ]; then
    log_debug "Input folder: \"$1\""
    BASE_FOLDER="$1"
  elif [ -f "$1" ] || { [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ] && [ -d "$(dirname "$1")" ] ; }; then
    log_debug "Input file: \"$1\""
    BASE_FOLDER="$(dirname "$1")"
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
find_gitignore_files () {
  if [ -d "$1" ]; then
    GITIGNORE_FILES=$(find "$1" -type f -name "$GIT_IGNORE_FILE_NAME")
  else
    GITIGNORE_FILES=$(find "$(dirname "$1")" -maxdepth 1 -type f -name "$GIT_IGNORE_FILE_NAME")
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
delete_dropboxignore_files () {
  if [ -d "$1" ]; then
    n_results=0
    while read -r file_path; do
      (( n_results++ ))
      rm "$file_path"
    done < <(find "$1" -type f -name "$DROPBOX_IGNORE_FILE_NAME")
    echo -e "$YELLOW Deleted files: $n_results $DEFAULT"
  elif [ -f "$1" ]; then
    if [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ]; then
      rm "$1"
      echo -e "$YELLOW Removed file: $(realpath --relative-to="$BASE_FOLDER" "$1") $DEFAULT"
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
find_dropboxignore_files () {
  DROPBOX_IGNORE_FILES=$(find "$1" -type f -name "$DROPBOX_IGNORE_FILE_NAME")
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
generate_dropboxignore_file () {
  dropboxignore_file_path="$(dirname "$1")/$DROPBOX_IGNORE_FILE_NAME"
  if [ -f "$dropboxignore_file_path" ]; then
    log_debug "Already existing file: $(realpath --relative-to="$BASE_FOLDER" "$dropboxignore_file_path")"
  else
    tee "$dropboxignore_file_path" > /dev/null << EOF
# ----
# Automatically Generated .dropboxignore file at $(date)
# ----
$(cat "${1}")
# ----
EOF
    echo -e "$GREEN Created file: $(realpath --relative-to="$BASE_FOLDER" "$dropboxignore_file_path") $DEFAULT"
  fi
}

#######################################
# uUpdate a .dropboxignore file based on changes on .gitignore file.
# Arguments:
#   dropboxingore file path to update.
# Outputs:
#   Update status.
#######################################
update_dropboxignore_file () {
  diff_content=$(diff --new-line-format="" --unchanged-line-format="" --ignore-blank-lines --ignore-tab-expansion --ignore-space-change --ignore-trailing-space -I "# [Automatically|-]" "${1}" "${2}")
  if [ -n "$diff_content" ]; then
    tee "$1" > /dev/null << EOF
# Automatically updated .dropboxignore file at "$(date)"
# ----
$diff_content
# ----
EOF
    echo -e "$GREEN Updated $(realpath --relative-to="$BASE_FOLDER" "$2") $DEFAULT"
  else
    log_debug "No changes found: $(realpath --relative-to="$BASE_FOLDER" "$2")"
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
update_dropboxignore_files () {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    dropboxignore_file="$(dirname "$gitignore_file")/$DROPBOX_IGNORE_FILE_NAME"
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
generate_dropboxignore_files () {
  find_gitignore_files "$1"
  for gitignore_file in $GITIGNORE_FILES; do
    if grep -q -P '^\s*!' "$gitignore_file" ; then
      echo -e "$YELLOW$(realpath --relative-to="$BASE_FOLDER" "$gitignore_file") contains exception patterns, will be ignored"
      continue
    fi
    current_dir="$(dirname "$gitignore_file")"
    dropboxignore_file="$current_dir/$DROPBOX_IGNORE_FILE_NAME"
    if [ -f "$dropboxignore_file" ]; then
      log_debug "Already existing file: $(realpath --relative-to="$BASE_FOLDER" "$dropboxignore_file")"
    else
      generate_dropboxignore_file "$gitignore_file"
      (( TOTAL_N_GENERATED_FILES++ ))
    fi
  done
  echo -e "$YELLOW
Total number of generated files: $TOTAL_N_GENERATED_FILES $DEFAULT"
}

#######################################
# Get file status.
# Globals:
#   FILE_ATTR_VALUE
#   FILE_ATTR_NAME
# Arguments:
#   Input file.
#######################################
file_ignore_status () {
  unset FILE_ATTR_VALUE
  case $MACHINE in
  Linux)
    FILE_ATTR_VALUE="$(getfattr --absolute-names --only-values -m "$FILE_ATTR_NAME" "$1")"
    ;;
  MacOS)
    FILE_ATTR_VALUE="$(xattr -p "$FILE_ATTR_NAME" "$1" 2> /dev/null)"
    ;;
  esac
}

#######################################
# Ignore file.
# Globals:
#   DROPBOX_IGNORE_FILE_NAME
#   BASE_FOLDER
# Arguments:
#   Input file.
#######################################
ignore_file () {
  file_ignore_status "$1"
  if [ "$(dirname "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ]; then
    log_debug "Bypass $(realpath --relative-to="$BASE_FOLDER" "$1")"
  elif [  -z "$FILE_ATTR_VALUE" ]; then
    case $MACHINE in
      Linux)
        attr -s "$FILE_ATTR_NAME" -V 1 "$1" > /dev/null
        (( TOTAL_N_IGNORED_FILES++ ))
        ;;
      MacOS)
        xattr -w "$FILE_ATTR_NAME" 1 "$1" > /dev/null
        (( TOTAL_N_IGNORED_FILES++ ))
        ;;
    esac
    log_debug "Ignored file: $(realpath --relative-to="$BASE_FOLDER" "$1")"
  else
    log_debug "Already ignored file: $(realpath --relative-to="$BASE_FOLDER" "$1")"
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
ignore_files () {
  if [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ]; then
    log_error "Cannot ignore an $DROPBOX_IGNORE_FILE_NAME. Choose another file or folder." 4
  elif [ -f "$1" ]; then
    ignore_file "$1"
  elif [ -d "$1" ]; then
    find_dropboxignore_files "$1"
    for dropboxignore_file in $DROPBOX_IGNORE_FILES; do
      file_total_results=0
      # shellcheck disable=SC2013
      if grep -q -P '^\s*!' "$dropboxignore_file" ; then
        echo -e "$YELLOW$(realpath --relative-to="$BASE_FOLDER" "$dropboxignore_file") contains exception patterns, will be ignored"
        continue
      fi
      while read -r file_pattern; do
#      for file_pattern in $(grep -v -P '^\s*$|^\s*\#|^\s*!' "$dropboxignore_file"); do
        file_pattern=${file_pattern%/}
        subdir="$(dirname "$file_pattern")"
        pattern="$(basename "$file_pattern")"
        n_results=0
        while read -r file_path; do
          ignore_file "$file_path"
          (( n_results++ ))
        done < <(find "$(dirname "$dropboxignore_file")/$subdir" -name "$pattern")
        file_total_results=$((file_total_results+n_results))
      done < <(grep -v -P '^\s*$|^\s*\#|^\s*!' "$dropboxignore_file")
      log_debug "Matched files because of '$(realpath --relative-to="$BASE_FOLDER" "$dropboxignore_file")': $file_total_results"
    done
    echo -e "$BLUE
Total number of ignored files: $TOTAL_N_IGNORED_FILES $DEFAULT"
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
list_ignored () {
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
      realpath --relative-to="$BASE_FOLDER" "$f_path"
      if [ -f "$f_path" ]; then
        (( total_ignored_files++ ))
      elif [ -d "$f_path" ]; then
        (( total_ignored_folders++ ))
      fi
    fi
  done < <(find "$1" -name "$filtering_pattern")
  echo -e "$YELLOW
Total number of ignored files: $total_ignored_files
Total number of ignored folders: $total_ignored_folders $DEFAULT"
}

#######################################
# Revert ignored file.
# Arguments:
#   Input file.
# Outputs:
#   Message about the reverted file.
#######################################
revert_ignored (){
  file_ignore_status "$1"
  if [ "$FILE_ATTR_VALUE" == 1 ]; then
    case $MACHINE in
      Linux)
        attr -r "$FILE_ATTR_NAME" "$1" > /dev/null
        ;;
      MacOS)
        xattr -d "$FILE_ATTR_NAME" "$1" > /dev/null
    esac

    log_debug "Reverted file: $(realpath --relative-to="$BASE_FOLDER" "$1")"
    (( TOTAL_N_REVERTED_FILES++ ))
  else
    log_debug "Already reverted file: $(realpath --relative-to="$BASE_FOLDER" "$1")"
  fi
}

#######################################
# Revert all ignored files.
# Arguments:
#   Input folder.
# Outputs:
#   Message about reverted files.
#######################################
revert_ignored_files () {
  if [ -f "$1" ]; then
    revert_ignored "$1"
  else
    while read -r file_path; do
      file_ignore_status "$file_path"
      if [ "$FILE_ATTR_VALUE" == 1 ]; then
        revert_ignored "$file_path"
      fi
    done < <(find "$1" -type f)
    echo -e "$BLUE
Total number of reverted files: $TOTAL_N_REVERTED_FILES $DEFAULT"
    TOTAL_N_REVERTED_FILES=0
    while read -r file_path; do
      file_ignore_status "$file_path"
      if [ "$FILE_ATTR_VALUE" == 1 ]; then
        revert_ignored "$file_path"
        (( n_results++ ))
      fi
    done < <(find "$1" -type d)
    echo -e "$BLUE
Total number of reverted folders: $TOTAL_N_REVERTED_FILES $DEFAULT"
  fi
}

#######################################
# Print help message.
# Outputs:
#   help message
#######################################
display_help () {
  cat << EOUSAGE
Usage: "$PROGRAM_NAME" <command> <path> [-v 0-2] [-p pattern]

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

#######################################
# The main function.
# Arguments:
#   Command
#   Path
#   Extra parameters
# Globals:
#   PROGRAM_NAME
#   VERBOSITY
#   FILTERING_PATTERN
#   MACHINE
# Output:
#   Almost everything.
#######################################
main () {
  if [ $# -eq 0 ]; then
    display_help
    return
  fi
  case $1 in
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

  while getopts ':pv:' opt; do
    case "$opt" in
      v) VERBOSITY=$OPTARG
         ;;
      p)
        FILTERING_PATTERN=$OPTARG
        ;;
      \?)
        echo "Unknown option: -$OPTARG"
        exit 3
        ;;
    esac
  done

  log_debug "Operating system: $MACHINE"

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
}

main "$@"

