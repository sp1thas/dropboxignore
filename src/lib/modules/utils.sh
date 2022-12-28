#!/bin/bash

#######################################
# Check OS.
# Globals:
#   MACHINE
#######################################
check_os() {
  case $MACHINE in
  Linux) ;;

  Darwin) ;;

  *)
    log_error "$MACHINE is not supported" 3
    ;;
  esac
}

#######################################
# Check system dependencies.
# Globals:
#   MACHINE
#######################################
check_dependencies() {
  if command -v realpath &>/dev/null; then
    log_debug "realpath command is installed"
  elif command -v python &>/dev/null; then
    log_debug "python is installed"
  else
    log_error "Neither realpath command not python could be found in you system"
  fi
  case $MACHINE in
  Linux)
    if ! command -v getfattr &>/dev/null; then
      log_error "attr package is not installed" 5
    fi
    if ! command -v attr &>/dev/null; then
      log_error "attr package is not installed" 5
    fi
    log_debug "attr package is installed"

    ;;
  Darwin)
    if ! command -v xattr &>/dev/null; then
      log_error "xattr package not installed" 5
    fi
    ;;
  *)
    log_error "$MACHINE is not supported" 3
    ;;
  esac
}

check_os

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
check_input() {
  if [ -z "$1" ]; then
    log_error "You have to provide a file or folder" 2
  elif [ -d "$1" ]; then
    log_debug "Input folder: \"$1\""
    BASE_FOLDER="$1"
  elif [ -f "$1" ] || { [ "$(basename "$1")" == "$DROPBOX_IGNORE_FILE_NAME" ] && [ -d "$(dirname "$1")" ]; }; then
    log_debug "Input file: \"$1\""
    BASE_FOLDER="$(dirname "$1")"
  else
    log_error "\"$1\" does not exists" 2
  fi
}

#######################################
# Get absolute path from relative path.
# Arguments:
#   Relative path.
#######################################
get_absolute_path() {
  if command -v realpath &>/dev/null; then
    realpath "$1"
  else
    python -c 'import os.path, sys;print(os.path.abspath(sys.argv[1]))' "$1"
  fi
}

#######################################
# Get relative path from absolute path.
# Arguments:
#   Absolute path.
#   Base Absolute path.
#######################################
get_relative_path() {
  if command -v realpath &>/dev/null; then
    realpath --relative-to="${2-$PWD}" "$1"
  else
    python -c 'import os.path, sys;print(os.path.relpath(sys.argv[1],sys.argv[2]))' "$1" "${2-$PWD}"
  fi
}

#######################################
# Find all .gitignore files.
# Globals:
#   GIT_IGNORE_FILE_NAME
# Arguments:
#   Input file or folder.
#######################################
find_gitignore_files() {
  if [ -d "$1" ]; then
    GITIGNORE_FILES=$(find "$1" -type f -name "$GIT_IGNORE_FILE_NAME")
  else
    GITIGNORE_FILES=$(find "$(dirname "$1")" -maxdepth 1 -type f -name "$GIT_IGNORE_FILE_NAME")
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
find_dropboxignore_files() {
  DROPBOX_IGNORE_FILES=$(find "$1" -type f -name "$DROPBOX_IGNORE_FILE_NAME")
}
